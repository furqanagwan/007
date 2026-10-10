import importlib.util
from pathlib import Path
import tempfile
import unittest


spec = importlib.util.spec_from_file_location(
    'check_repository', Path(__file__).parents[1] / 'check_repository.py')
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class RepositoryChecksTests(unittest.TestCase):
    def test_links_decode_spaces_and_check_html_and_references(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'Game Name').mkdir()
            (root / 'Game Name/README.md').write_text('Game')
            (root / 'README.md').write_text(
                '[game](Game%20Name/README.md#section)\n'
                '<a href="Game%20Name/README.md"><img src="missing.png"></a>\n'
                '[reference]: missing.md\n'
                '[web](https://example.com) [section](#section)\n'
                '```markdown\n[example](untracked.md)\n```\n')
            problems = checker.check_files(root, ['README.md'])
            self.assertEqual(len(problems), 2, problems)
            self.assertTrue(any('missing.png' in problem for problem in problems))
            self.assertTrue(any('missing.md' in problem for problem in problems))

    def test_nested_and_root_relative_links(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'docs').mkdir()
            (root / 'README.md').write_text('Root')
            (root / 'docs/page.md').write_text(
                '[root](../README.md) [absolute](/README.md)\n')
            self.assertEqual(checker.check_files(root, ['docs/page.md']), [])

    def test_toml_syntax_is_parsed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'good.toml').write_text('[title]\nname = "Game"\n')
            (root / 'bad.toml').write_text('[title\n')
            problems = checker.check_files(root, ['good.toml', 'bad.toml'])
            self.assertEqual(len(problems), 1)
            self.assertIn('bad.toml: invalid TOML', problems[0])


if __name__ == '__main__':
    unittest.main()
