# Using containers with Nexflow on our servers

Nextflow is a tool for managing bioinformatics workflows. It is essential to many of our processes in the core. Using container runtimes (e.g. docker, podman, apptainer) in conjunction with Nextflow dramatically improves the flexibility of our workflows and increase our productivity as a core.

## Podman

When I try to run a nextflow pipeline that calls podman internally, nextflow runs this command:
```
podman run -i -v /yerkes-cifs/runs:/yerkes-cifs/runs -w "$PWD" --cpu-shares 1024 docker.io/micahpf/samtools:1.17 /bin/bash
```
Which results is the following error:
```
Resource limits are not supported and ignored on cgroups V1 rootless systems
Error: OCI runtime error: runc: runc create failed: unable to start container process: error during container init: error setting cgroup config for procHooks process: cannot set cpu limit: container could not join or create cgroup
```

The command above works fine if I simply run it with `sudo` in front, but [it's not possible to tell nextflow](https://github.com/nextflow-io/nextflow/discussions/2214#discussioncomment-994501) to run container runtimes with root prviledges unless that's the default behavior (such as with docker).

It also works fine if I remove the `--cpu-shares 1024`, but nextflow needs to be able to limit resources on containers.

Note that all our servers use *cgroups v1*, [which doesn't support resource limiting on rootless containers](https://github.com/containers/podman/issues/17582#issuecomment-1438261366), but *cgroups v2* does support this behavior.

However, cgroups v2 isn't installed with the any of our servers, the three older of which are running RHEL 7.9 (Maipo) and the three newer of which are running RHEL 8.9 (Ootpa). In fact, [cgroups v2 isn't even fully supported on any RHEL releases below RHEL 9](https://kubernetes.io/docs/concepts/architecture/cgroups/#linux-distribution-cgroup-v2-support).

Unfortunately, simply upgrading to RHEL 9 isn't ideal either, because podman isn't officially supported by many community tools ([including nextflow](https://www.nextflow.io/docs/latest/container.html#podman)) and [docker doesn't support RHEL x86_64 as a platform](https://docs.docker.com/engine/install/).

## Solution: Upgrade to RHEL 9 and use Apptainer instead of Podman

RHEL 9 by default uses cgroups-v2, which solves the container resource limiting issue. Apptainer supports RHEL and resource limiting on rootless container with cgroups-v2.


