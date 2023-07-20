{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import crictl with context -%}
{%- from tplroot ~ "/vars.jinja" import
    package_dir, package_source, package_source_hash,
    crictl_bin_path
with context -%}
{%- from "common/vars.jinja" import
    nobody_groupname
-%}

include:
  - debian/packages/ca-certificates

crictl-download:
  archive.extracted:
    - name: {{ package_dir }}
    - source: {{ package_source }}
    - source_hash: {{ package_source_hash }}
    - archive_format: tar
    - enforce_toplevel: False
    - options: v
    - user: nobody
    - group: {{ nobody_groupname }}
    - keep: True
    - if_missing: {{ package_dir }}
    - require:
      - pkg: ca-certificates

crictl:
  file.copy:
    - name: {{ crictl_bin_path }}
    - mode: 755
    - user: root
    - group: root
    - source: {{ package_dir }}/crictl
    - force: True
{%- if salt['file.file_exists'](crictl_bin_path) %}
    - onchanges:
{%- else %}
    - require:
{%- endif %}
      - archive: crictl-download
