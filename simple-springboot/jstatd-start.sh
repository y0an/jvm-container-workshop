#!/bin/sh
policy=${HOME}/.jstatd.all.policy
[ -r ${policy} ] || cat >${policy} <<'POLICY'
grant codebase "file:${java.home}/../lib/tools.jar" {
permission java.security.AllPermission;
};
POLICY

jstatd -J-Djava.security.policy=${policy} &