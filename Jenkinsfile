podTemplate(
    label: "kubernetes",
     containers: [
         containerTemplate(name: "maven", image: "maven:alpine", ttyEnabled: true, command: "cat"),
         containerTemplate(name: 'docker', image: 'docker', command: 'cat', ttyEnabled: true)
      ],

     volumes: [
                hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
        ]
) {
    imagename = "v" + "-"   + env.BUILD_NUMBER
    env.IMAGE = "vipindevops/demopetclinic"
    env.TAG = "${imagename}"
    env.REPO = "https://github.com/vipin-k/dockerpetclinic.git"
    def app_name = 'code'
     node("kubernetes") {
         stage('Checkout') {
            git "${env.REPO}"
        }
         container("maven") {
            stage("build") {
                dir ("./${app_name}"){
                sh 'mvn -Dmaven.test.failure.ignore clean'
                sh 'mvn -Dmaven.test.failure.ignore test'
                sh 'mvn -Dmaven.test.failure.ignore package'
                }
             }
             stage("unit-test") 
                {
                dir ("./${app_name}"){
                junit '**/target/surefire-reports/TEST-*.xml'
              }
             }
         }
         container("docker") {
             stage("build") {
                 sh """docker image build -t ${env.IMAGE}:${env.TAG} ."""
                withCredentials([usernamePassword(
                credentialsId: "docker",
                usernameVariable: "USER",
                passwordVariable: "PASS"
                    )])
                    {
                 sh """docker login -u $USER -p $PASS"""
                    }
                 sh """docker image push ${env.IMAGE}:${env.TAG}"""
             }
         }
     }
 }
