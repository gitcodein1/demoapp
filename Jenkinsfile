pipeline {
    agent {
        label 'node1'
    }
    tools {
      maven 'mvn3'
    }

    stages {
        stage("Build") {
            steps {
                sh 'mvn package'
            }
        }
        stage("Upload Artifact") {
            steps {
                script {
                    def mvnPom = readMavenPom file: 'pom.xml'
                    def nexusRepo = mvnPom.version.endsWith("SNAPSHOT") ? "demo-maven-snapshot-repo" : "demo-maven-release-repo"
                    
                    nexusArtifactUploader artifacts: [[
                                                        artifactId: 'demo-app',
                                                        file: "target/demo-app-${mvnPom.version}.war", 
                                                        type: 'war'
                                                     ]], 
                                                    
                                                    credentialsId: 'nexuscred', 
                                                    groupId: 'com.demo', 
                                                    nexusUrl: '172.17.0.4:8081', 
                                                    nexusVersion: 'nexus3', 
                                                    protocol: 'http', 
                                                    repository: nexusRepo, 
                                                    version: "${mvnPom.version}"
                }
            }
        }
    }
}
