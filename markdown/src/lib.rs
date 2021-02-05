use pulldown_cmark::{
    escape::{escape_href, escape_html},
    html, CowStr, Event, LinkType, Options, Parser, Tag,
};

fn extract_links_from_parser<'a>(
    p: impl Iterator<Item = Event<'a>>,
    l: &'a mut Vec<String>,
) -> impl Iterator<Item = Event<'a>> {
    p.map(move |event| match event {
        Event::Start(Tag::Link(_, ref dest, _)) => {
            if dest.starts_with('/') {
                l.push(dest.clone().into_string());
            }
            event
        }
        _ => event,
    })
}

fn phoenixify_links(e: Event) -> Event {
    match e {
        Event::Start(Tag::Link(LinkType::Email, _, _)) => e,
        Event::Start(Tag::Link(_, dest, title)) if dest.starts_with('/') => {
            let mut html = String::new();
            html.push_str("<a data-phx-link=\"redirect\" data-phx-link-state=\"push\" href=\"");
            escape_href(&mut html, &dest).unwrap();
            if !title.is_empty() {
                html.push_str("\" title=\"");
                escape_html(&mut html, &title).unwrap();
            }
            html.push_str("\">");

            Event::Html(CowStr::Boxed(html.into_boxed_str()))
        }
        _ => e,
    }
}

pub fn render_simple(input: &str) -> String {
    let parser = Parser::new_ext(input, Options::all());
    let parser = parser.map(phoenixify_links);
    let mut output = String::new();
    html::push_html(&mut output, parser);
    output
}

pub fn extract_links(input: &str) -> Vec<String> {
    let parser = Parser::new_ext(input, Options::empty());
    let mut local_links = Vec::new();
    extract_links_from_parser(parser, &mut local_links).for_each(drop);
    local_links
}

pub fn render_and_extract_links(input: &str) -> (String, Vec<String>) {
    let parser = Parser::new_ext(input, Options::all());

    let mut local_links = Vec::new();
    let parser = extract_links_from_parser(parser, &mut local_links);
    let parser = parser.map(phoenixify_links);

    let mut output = String::new();
    html::push_html(&mut output, parser);
    (output, local_links)
}

#[cfg(test)]
mod tests {
    use pulldown_cmark::{html, BrokenLink, LinkType, Options, Parser};

    use super::*;

    #[test]
    fn test_phoenixify_links() {
        let input = "[Inline Link](/notes/1) [External link](http://example.com)";
        let output = render_simple(input);

        let expected = "<p><a data-phx-link=\"redirect\" data-phx-link-state=\"push\" href=\"/notes/1\">Inline Link</a> <a href=\"http://example.com\">External link</a></p>\n";
        assert_eq!(expected, output);
    }

    #[test]
    fn extract_link() {
        let (_, links) =
            render_and_extract_links("[Inline Link](/notes/1) [External link](http://example.com)");
        assert_eq!(vec!["/notes/1"], links);

        let (_, links) = render_and_extract_links("[Shortcut Link]\n\n[Shortcut Link]: /notes/1");
        assert_eq!(vec!["/notes/1"], links);

        let links = extract_links("[Inline Link](/notes/1) [External link](http://example.com)");
        assert_eq!(vec!["/notes/1"], links);

        let links = extract_links("[Shortcut Link]\n\n[Shortcut Link]: /notes/1");
        assert_eq!(vec!["/notes/1"], links);
    }

    #[test]
    fn basic_example() {
        let input = "Hello world, this is a ~~complicated~~ *very simple* example.";

        let output = render_simple(input);

        let expected =
            "<p>Hello world, this is a <del>complicated</del> <em>very simple</em> example.</p>\n";

        assert_eq!(expected, &output);
    }

    #[test]
    fn broken_link() {
        let input = "Hello world [broken] [invalid_broken][yoink]";

        let mut callback = |broken_link: BrokenLink| {
            if broken_link.link_type == LinkType::Shortcut {
                if &input[broken_link.span] == "[broken]" {
                    Some(("Yeet".into(), "Yoink".to_owned().into()))
                } else {
                    None
                }
            } else {
                None
            }
        };

        let parser =
            Parser::new_with_broken_link_callback(input, Options::empty(), Some(&mut callback));

        let mut output = String::new();
        html::push_html(&mut output, parser);

        let expected = "<p>Hello world <a href=\"Yeet\" title=\"Yoink\">broken</a> [invalid_broken][yoink]</p>\n";

        assert_eq!(expected, &output);
    }
}
