use rustler::{Encoder, Env, Error, Term};
use markdown;

rustler::rustler_export_nifs! {
    "Elixir.Markdown",
    [
        ("render_simple", 1, render_simple)
    ],
    None
}

fn render_simple<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let input: &str = args[0].decode()?;

    let res = markdown::render_simple(input);

    Ok((res).encode(env))
}
