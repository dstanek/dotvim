import path
import os
import vim


def find_project_root(directory):
    while directory:
        if (directory.joinpath('.hg').exists() or
                directory.joinpath('.git').exists()):
            return directory
        directory = directory.joinpath('..').normpath()
    return ''


def find_AGI_style_test_file(current_dir, test_base_fn):
    test_fn = current_dir.joinpath('tests', test_base_fn)
    if test_fn.exists():
        return test_fn


def find_segmented_open_source_library_test_file(project_root, test_base_fn):
    """This style defines tests/unit and tests/system in the project root."""
    test_fn = project_root.joinpath('tests/unit', test_base_fn)
    if test_fn.exists():
        return test_fn


def find_flat_open_source_library_test_file(project_root, test_base_fn):
    """This style defines tests in the project root."""
    test_fn = project_root.joinpath('tests', test_base_fn)
    if test_fn.exists():
        return test_fn


def find_django_project_test_file(current_dir, project_dir, test_base_fn):
    test_dir = current_dir

    def find_django_app_dir(directory):
        while directory != project_dir: # and directory != path.path('/'):
            if directory.joinpath('models.py').exists():
                return directory.joinpath('tests')
            directory = directory.joinpath('..').normpath()

    app_dir = find_django_app_dir(current_dir)
    if not app_dir:
        return

    app_dir_parts = app_dir.abspath().split(os.sep)
    current_dir_parts = current_dir.abspath().split(os.sep)
    new_test_fn = 'test_' + '_'.join(current_dir_parts[len(app_dir_parts):]) + test_base_fn[4:]
    return app_dir.joinpath(new_test_fn)


def find_tests_for_current_file():
    current_fn = vim.current.buffer.name
    open('/tmp/vim.debugging', 'a').write('.... \n')
    open('/tmp/vim.debugging', 'a').write('.... %r\n' % path)
    open('/tmp/vim.debugging', 'a').write('.... %r\n' % path.path)
    base_fn = path.path(current_fn).basename()
    if base_fn.startswith('test'):
        vim.command('return %r' % current_fn)
        return

    test_base_fn = 'test_' + base_fn
    current_dir = path.path(current_fn).dirname()

    test_fn = find_AGI_style_test_file(current_dir, test_base_fn)
    open('/tmp/vim.debugging', 'a').write('AGI %r\n' % test_fn)
    if test_fn:
        vim.command('return "%s"' % test_fn)
        return

    project_root = find_project_root(current_dir)

    test_fn = find_django_project_test_file(
            current_dir, project_root, test_base_fn)
    open('/tmp/vim.debugging', 'a').write('OSS %r\n' % test_fn)
    if test_fn and test_fn.exists():
        vim.command('return "%s"' % test_fn)
        return

    test_fn = find_segmented_open_source_library_test_file(
            project_root, test_base_fn)
    open('/tmp/vim.debugging', 'a').write('Y %r\n' % test_fn)
    if test_fn and test_fn.exists():
        vim.command('return "%s"' % test_fn)
        return

    test_fn = find_flat_open_source_library_test_file(
            project_root, test_base_fn)
    open('/tmp/vim.debugging', 'a').write('PPP %s\n' % test_fn)
    if test_fn and test_fn.exists():
        vim.command('return "%s"' % test_fn)
        return

    vim.command("return ''")
    return


def find_test_dir_for_current_file():
    current_fn = vim.current.buffer.name
    current_dir = path.path(current_fn).dirname()
    project_root = find_project_root(current_dir)
    test_dir = project_root.joinpath('tests')
    if test_dir.exists():
        vim.command('return %r' % test_dir)
    else:
        vim.command('return %r' % project_root)


def get_pylint_command():
    current_fn = vim.current.buffer.name
    return ("(echo '[%(current_fn)s]';"
            "pylint -i y %(current_fn)s | "
            "grep -e '^[FWECRY]' | "
            "sed -e 's/^E/1 E /' "
                "-e 's/^W/2 W /' "
                "-e 's/^C/3 C /' | "
            "sort -k1,3)")
