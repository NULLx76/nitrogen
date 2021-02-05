use rustler::{Encoder, Env, Error, Term};
use std::collections::HashMap;

rustler::rustler_export_nifs! {
    "Elixir.Markdown",
    [
        ("render_and_extract_links", 2, render_and_extract_links)
    ],
    None
}

fn render_and_extract_links<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input = args[0].decode()?;
    let lookup: Vec<(&str, i32)> = args[1].decode()?;
    let map: HashMap<&str, i32> = lookup.into_iter().collect();

    let res = markdown::render_and_extract_links(input, map);
    Ok((res).encode(env))
}
