FROM arm32v7/openjdk:8-slim

ENV user=jenkins \
    group=jenkins \
    uid=1000 \
    gid=1000 \
    BIN /usr/local/bin \
    JENKINS_HOME /var/jenkins_home \
    JENKINS_WAR  /usr/share/jenkins/jenkins.war \
    JENKINS_SUPPORT ${BIN}/jenkins-support \
    INSTALL_PLUGINS_SH ${BIN}/install-plugins.sh \
    PLUGINS_SH ${BIN}/plugins.sh \
    JENKINS_SH ${BIN}/jenkins.sh \
    COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log \
    JENKINS_UC https://updates.jenkins.io \
    JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental


RUN apt-get update \
     && apt-get install -y git curl \
     && apt-get upgrade -y \
     && rm -rf /var/lib/apt/lists/* \
     && groupadd -g ${gid} ${group} \
     && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
     && mkdir -p /usr/share/jenkins/ref/init.groovy.d \
     && chown -R ${uid}:${gid} /usr/share/jenkins \
     && chmod ug+rw /usr/share/jenkins

ENV JENKINS_VERSION 2.107.3

# Install scrips from Jenkins git repo
ADD https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh ${INSTALL_PLUGINS_SH}
ADD https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support ${JENKINS_SUPPORT}
ADD https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh ${PLUGINS_SH}
ADD https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh ${JENKINS_SH}

# Downloading Jenkins
ADD http://mirrors.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war.sha256 ${JENKINS_WAR}.sha256
ADD http://mirrors.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war ${JENKINS_WAR}

# Verify Download
# makeing it executable 
RUN cd /usr/share/jenkins/ \
     && sha256sum -c jenkins.war.sha256 \
     && chmod -R ugo+rx ${BIN} ${JENKINS_WAR}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME ${JENKINS_HOME}

USER ${user}
CMD [ "/usr/local/bin/jenkins.sh" ]