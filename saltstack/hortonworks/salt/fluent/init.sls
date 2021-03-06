{% set os = salt['environ.get']('OS') %}

{% if os.startswith("centos") or os.startswith("redhat") %}
install_fluentd_yum:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
{% elif os.startswith("ubuntu") %}
  {% if os == "ubuntu18" %}
install_fluentd_ubuntu18:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent3.sh | sh
  {% elif os == "ubuntu16" %}
install_fluentd_ubuntu16:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh
  {% elif os == "ubuntu14" %}
install_fluentd_ubuntu14:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent3.sh | sh
  {% else %}
warning_fluentd_ubuntu:
  cmd.run:
    - name: echo "Warning - Fluentd install is not supported for this Ubuntu OS version ({{ os }})"
  {% endif %}
{% elif os.startswith("debian") %}
  {% if os == "debian9" %}
install_fluentd_debian9:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent3.sh | sh
  {% elif os == "debian8" %}
install_fluentd_debian8:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent3.sh | sh
  {% else %}
warning_fluentd_debian:
  cmd.run:
    - name: echo "Warning - Fluentd install is not supported for this Debian OS version ({{ os }})"
  {% endif %}
{% elif os.startswith("sles") %}
warning_fluentd_suse:
  cmd.run:
    - name: echo "Warning - Fluentd install is not supported yet for Suse ({{ os }})"
{% elif os == "amazonlinux2" %}
install_fluentd_amazon2:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent3.sh | sh
{% elif os == "amazonlinux" %}
install_fluentd_amazon1:
  cmd.run:
    - name: curl -L https://toolbelt.treasuredata.com/sh/install-amazon1-td-agent3.sh | sh
{% else %}
warning_fluentd_os:
  cmd.run:
    - name: echo "Warning - Fluentd install is not supported for this OS type ({{ os }})"
{% endif %}

install_fluentd_plugins:
  cmd.run:
    - name: /opt/td-agent/embedded/bin/fluent-gem install fluent-plugin-cloudwatch-logs
    - onlyif: test -d /opt/td-agent/embedded/bin/