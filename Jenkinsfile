pipeline {
  agent any
  stages {
    stage('Clone repository') {
      steps {
        checkout scm
      }
    }
    stage('Prep') {
      steps {
        script {
          env.GIT_HASH = sh(
                script: "git show --oneline | head -1 | cut -d' ' -f1",
                returnStdout: true
              ).trim()
            }
        }
    }
    // stage('Lint Dockerfiles') {
    //   parallel {
    //     stage('Lint Ambari Image') {
    //         steps {
    //             script {
    //                 docker.image('hadolint/hadolint:latest-debian').inside() {
    //                     sh 'hadolint ./containers/ambari-server/Dockerfile'
    //                 }
    //             }
    //         }
    //     }
    //     stage('Lint Node Image') {
    //         steps {
    //             script {
    //                 docker.image('hadolint/hadolint:latest-debian').inside() {
    //                     sh 'hadolint ./containers/node/Dockerfile'
    //                 }
    //             }
    //         }
    //     }
    //     stage('Lint Postgres Image') {
    //         steps {
    //             script {
    //                 docker.image('hadolint/hadolint:latest-debian').inside() {
    //                     sh 'hadolint ./containers/postgres/Dockerfile'
    //                 }
    //             }
    //         }
    //     }
    //   }
    // }
    stage('Build Images') {
      parallel {
        stage('Build Ambari-Server Image') {
          steps {
              script {
                ambari = docker.build("ambari-server", "--build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg NO_PROXY=$NO_PROXY ./containers/node")
              }
          }
        }
        stage('Build Master Image') {
          steps {
              script {
                master = docker.build("master", "--build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg NO_PROXY=$NO_PROXY ./containers/node")
              }
          }
        }
        stage('Build Worker Image') {
          steps {
              script {
                worker = docker.build("worker", "--build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg NO_PROXY=$NO_PROXY ./containers/node")
              }
          }
        }
        stage('Build Postgres Image') {
          steps {
              script {
                postgres = docker.build("postgres", "--build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg NO_PROXY=$NO_PROXY ./containers/postgres")
              }
          }
        }
        stage('Build IPA Image') {
          steps {
              script {
                ipa = docker.build("kdc", "--build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY --build-arg NO_PROXY=$NO_PROXY ./containers/ipa")
              }
          }
        }
      }
    }
    stage('Test/Scan Images') {
      parallel {
        // stage('Scan ambari image for vulnerabilities') {
        //     steps {
        //         script {
        //             withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'aquasec-microscanner-token',
        //                                 passwordVariable: 'TOKEN',
        //                                 usernameVariable: 'USER']]) {

        //                 ambari.inside("-u root --env \"MICROSCANNER_TOKEN=${env.TOKEN}\" --env https_proxy=$HTTPS_PROXY --env HTTPS_PROXY=$HTTPS_PROXY --env http_proxy=$HTTP_PROXY --env HTTP_PROXY=$HTTP_PROXY"){
        //                     sh 'mkdir -p /usr/local/bin'
        //                     sh 'env'
        //                     sh 'curl https://get.aquasec.com/microscanner -o /usr/local/bin/microscanner'
        //                     sh 'chmod +x /usr/local/bin/microscanner'
        //                     sh '/usr/local/bin/microscanner $MICROSCANNER_TOKEN'
        //                 }
        //             }
        //         }
        //     }
        // }
        stage('Test Ambari Image') {
          steps {
            script {
              postgres.inside {
                sh 'echo "Do some stuff"'
              }
            }

          }
        }
        stage('Test Master Image') {
          steps {
            script {
              postgres.inside {
                sh 'echo "Do some stuff"'
              }
            }

          }
        }
        stage('Test Worker Image') {
          steps {
            script {
              postgres.inside {
                sh 'echo "Do some stuff"'
              }
            }

          }
        }
        stage('Test Postgres Image') {
          steps {
            script {
              postgres.inside {
                sh 'echo "Do some stuff"'
              }
            }

          }
        }
        stage('Test IPA Image') {
          steps {
            script {
              ipa.inside {
                sh 'echo "Do some stuff"'
              }
            }

          }
        }
      }
    }
    stage('Push Images') {
      parallel {
        stage('Push Ambari Image') {
          steps {
              script {
                docker.withRegistry("$REGISTRY_URL", 'nexus-credentials') {
                  ambari.push("latest")
                  ambari.push("${GIT_HASH}")
                }
              }
          }
        }
        stage('Push Master Image') {
          steps {
              script {
                docker.withRegistry("$REGISTRY_URL", 'nexus-credentials') {
                  master.push("worker")
                  master.push("${GIT_HASH}")
                }
              }
          }
        }
        stage('Push Worker Image') {
          steps {
            script {
                docker.withRegistry("$REGISTRY_URL", 'nexus-credentials') {
                    worker.push("master")
                    worker.push("${GIT_HASH}")
                }
            }
          }
        }
        stage('Push Postgres Image') {
          steps {
            script {
                docker.withRegistry("$REGISTRY_URL", 'nexus-credentials') {
                    postgres.push("latest")
                    postgres.push("${GIT_HASH}")
                }
            }
          }
        }
        stage('Push IPA Image') {
          steps {
                script {
                  docker.withRegistry("$REGISTRY_URL", 'nexus-credentials') {
                    ipa.push("latest")
                    ipa.push("${GIT_HASH}")
                  }
                }
            }
        }
      }
    }
  }
  environment {
    HTTP_PROXY = '"http://dmz-proxy-01.sandbox.local:3128"'
    HTTPS_PROXY = '"http://dmz-proxy-01.sandbox.local:3128"'
    NO_PROXY = '"registry.service.consul"'
    REGISTRY_URL = 'https://registry:443'
  }
}