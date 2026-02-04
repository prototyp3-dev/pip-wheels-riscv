#!/bin/env python
import argparse
import pathlib


HTML_TEMPLATE = """<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Wheel Package Index</title>
  </head>
  <body>
    <h1>Wheel Package Index</h1>
    <ul>
{list_items}
    </ul>
  </body>
</html>
"""

# 'https://raw.githubusercontent.com/prototyp3-dev/pip-wheels-riscv/main/wheels/'
BASE_URL = (
    'https://github.com/prototyp3-dev/pip-wheels-riscv/raw/refs/heads/main/wheels/'
)


def write_index(dest, wheels):
    """
    Generate an Index page containing links to all wheels, and write it to
    `dest` file.
    """
    with dest.open('wt') as fout:
        items = []
        for wheel in wheels:
            name = wheel.name
            url = BASE_URL + str(wheel)
            items.append(
                f'      <li><a href="{url}">{name}</a></li>'
            )

        fout.write(HTML_TEMPLATE.format(list_items='\n'.join(items)))


def find_wheels(base_dir):
    """
    Returns a list of PosixPath objects representing available wheel files
    """
    wheels = base_dir.glob('**/*.whl')
    wheels = [x.relative_to(base_dir) for x in wheels]
    return wheels


def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="Build an index.html file with links to python wheel "
                    "files, suitable to be used with the --find-link option "
                    "of pip install."
    )

    parser.add_argument(
        'base_dir',
        type=pathlib.Path,
        default=pathlib.Path.cwd(),
        nargs='?',
        help='base directory to look for the wheel files and generate the '
             'index.html file into.'
    )

    args = parser.parse_args()

    base_dir = args.base_dir.resolve()

    wheels = find_wheels(base_dir)
    print(f'Found {len(wheels)} wheel files')

    destination_file = base_dir / 'index.html'
    print(f'Generating {str(destination_file)}')
    write_index(destination_file, wheels)


if __name__ == '__main__':
    main()
