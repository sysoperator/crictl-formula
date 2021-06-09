{% from "crictl/map.jinja" import crictl with context %}

{% from "crictl/vars.jinja" import
    package_dir, package_source, package_source_hash,
    crictl_bin_path
with context %}

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
    - group: nogroup
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
{% if salt['file.file_exists'](crictl_bin_path) %}
    - onchanges:
{% else %}
    - require:
{% endif %}
      - archive: crictl-download
