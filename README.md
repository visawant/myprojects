# Mediawiki Helm Charts Deployment
I have used azure devops classic editor pipeline to create release pipeline for mediawiki helm chart deployment
We can also create azure-pipeline.yaml for pipeline as a code feature
Since we are using helm charts , it is easy to do release management i.e. rollback , upgrade of helm chart versions
I have added inline bash script which will pull mediawiki helm chart from bitnami repo and install the chart on aks cluster
