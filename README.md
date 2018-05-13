This Image is heavily influenced by https://github.com/jenkinsci/docker and uses some of the scripts from it.

# Jenkins image for Raspberry pi

This is a base image, to install extra plugins, do like the orginal  https://github.com/jenkinsci/docker and make you're own image

```Dockerfile
FROM jenkins/jenkins:lts
RUN /usr/local/bin/install-plugins.sh docker-slaves github-branch-source:1.8
```