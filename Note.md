Github OAuth: https://backstage.io/docs/auth/github/provider/
Secret: 217ce8505fdaf2de94d850d45c35873d51b943d8
ID: 7bddff430630ee6f9ed1
PAT: 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


- Repo modules is out of dated, multiple places are hard coded, need to optimized later, also some attribute is not supported by AWS, need to remove.
- Step to run in readme: make, make terraform-cli, tf init, tf apply
- S3 and Dynamo Lock table created manually, resource group created manually to manage resources: https://ap-southeast-1.console.aws.amazon.com/resource-groups/group/BackStage_ResourceGroup?region=ap-southeast-1
- Step to run in readme: 
```
    make, make terraform-cli, tf init, tf apply
    docker build . -f packages/backend/Dockerfile --tag backstage
    docker tag backstage 046399964077.dkr.ecr.ap-southeast-1.amazonaws.com/backstage-image:1.0.0
    aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 046399964077.dkr.ecr.ap-southeast-1.amazonaws.com
    docker push 046399964077.dkr.ecr.ap-southeast-1.amazonaws.com/backstage-image:1.0.0
```

- https://backstage.io/docs/getting-started/
    - install nvm, nvm use 20 (brew install nvm, brew install yarn): nvm install 20, nvm use 20, np
    - setup standalone app:  npx @backstage/create-app@latest
    -   Run the app: cd backstage-demo && yarn dev, Set up the software catalog: https://backstage.io/docs/features/software-catalog/configuration, Add authentication: https://backstage.io/docs/auth/
