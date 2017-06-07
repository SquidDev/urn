#! /usr/bin/env python3
import re, shutil, os.path, mistune

class BBRenderer(mistune.Renderer):
	def block_code(self, code, lang):
		return "[code]\n%s\n[/code]\n" % code
	def block_quote(self, text):
		return "[quote]%s[/quote]" % text
	def header(self, text, level, raw):
		return "[size=%d][b]%s[/b][/size]\n" % (7 - level, text)
	def list(self, body, ordered=True):
		if ordered:
			return "[list=1]\n%s[/list]\n" % body
		else:
			return "[list]\n%s[/list]\n" % body
	def list_item(self, text):
		return "[*]%s\n" % text
	def paragraph(self, text):
		return "%s\n\n" % text.replace("\n", " ")
	def link(self, link, title, content):
		return "[url=%s]%s[/url]" % (link, content)
	def image(self, src, title, alt_text):
		return "[img]%s[/img]" % (src.replace("{{ site.baseurl }}", "https://squiddev.github.io/urn"))
	def codespan(self, text):
		return "[font=courier new,courier,monospace]%s[/font]" % text
	def emphasis(self, text):
		return "[i]%s[/i]" % text
	def double_emphasis(self, text):
		return "[b]%s[/b]" % text
	def newline(self):
		return ""
	def linebreak(self):
		return ""

markdown = mistune.Markdown(renderer=BBRenderer(escape=True))

def convert(inp, out):
	with open(inp, "r") as h:
		txt = h.read()

	txt = re.sub(r"^\-{3}\n.*?\n\-{3}\n", "", txt, 0, re.S)
	res = markdown(txt)

	with open(out, "w") as h:
		h.write(res)

if __name__ == "__main__":
	inp = "_posts"
	out = "_posts_out"

	if os.path.isdir(out):
		shutil.rmtree(out)
	os.mkdir(out)

	count = 0
	for path in os.scandir(inp):
		if path.name.endswith(".md"):
			convert(os.path.join(inp, path.name), os.path.join(out, path.name[:-3] + ".txt"))
			count += 1
	print("Converted %d files from %s to %s" % (count, inp, out))
