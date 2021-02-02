use rustler::{Encoder, Env, Error, Term};
use markdown;

rustler::rustler_export_nifs! {
    "Elixir.Markdown",
    [
        ("render_simple", 1, render_simple),
        ("extract_links", 1, extract_links),
        ("render_extract_links", 1, render_simple_extract_local_links)
    ],
    None
}

fn render_simple<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input: &str = args[0].decode()?;
    let res = markdown::render_simple(input);
    Ok((res).encode(env))
}


fn render_simple_extract_local_links<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input: &str = args[0].decode()?;
    let res = markdown::render_and_extract_links(input);
    Ok((res).encode(env))
}

fn extract_links<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input: &str = args[0].decode()?;
    let res = markdown::extract_links(input);
    Ok((res).encode(env))
}
