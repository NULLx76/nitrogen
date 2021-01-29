#[cfg(test)]
mod tests {
    use pulldown_cmark::{Parser, Options, html, BrokenLink, LinkType};

    #[test]
    fn basic_example() {
        let input = "Hello world, this is a ~~complicated~~ *very simple* example.";

        let mut options = Options::empty();
        options.insert(Options::ENABLE_STRIKETHROUGH);

        let parser = Parser::new_ext(input, options);

        let mut output = String::new();
        html::push_html(&mut output, parser);

        let expected = "<p>Hello world, this is a <del>complicated</del> <em>very simple</em> example.</p>\n";

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

        let parser = Parser::new_with_broken_link_callback(input, Options::empty(), Some(&mut callback));

        let mut output = String::new();
        html::push_html(&mut output, parser);

        let expected = "<p>Hello world <a href=\"Yeet\" title=\"Yoink\">broken</a> [invalid_broken][yoink]</p>\n";

        assert_eq!(expected, &output);
    }
}
