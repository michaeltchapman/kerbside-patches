#!/usr/bin/python

import jinja2

JOBS = {
    'functional-tests': [
        {
            'name': 'rocky-9-nova',
            'baseimage': 'sf://label/ci-images/rocky-9',
            'baseuser': 'cloud-user',
            'targets': ['nova-2023.1', 'nova-2023.2', 'nova-2024.1', 'nova']
        },
        {
            'name': 'debian-12-nova',
            'baseimage': 'sf://label/ci-images/debian-12',
            'baseuser': 'debian',
            'targets': ['nova-2023.1', 'nova-2023.2', 'nova-2024.1', 'nova']
        },
    ],
}


if __name__ == '__main__':
    for style in JOBS.keys():
        with open('%s.tmpl' % style) as f:
            t = jinja2.Template(f.read())

        for job in JOBS[style]:
            with open('%s-%s.yml' % (style, job['name']), 'w') as f:
                f.write(t.render(job))
