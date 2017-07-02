# State Dance Project (powered by WSO2 Ballerina)

The following project is desinged to create **User Tasks** using Github issues for asynchronous service orchestrations.
![Architecture diagram](https://github.com/amalhub/state-dance/blob/master/resources/state-dance-diagram.png "Architecture diagram")
### How to run
1. Download and deploy the **/ballerina/ApprovalService.bal** file in ballerina server.
   * Make sure to update the configurations.
       * **loanOfficer** - Github account user id
       * **git** - Github url
       * **clientID** - For Gmail connector
       * **clientSecret** - For Gmail connector
       * **accessToken** - For Gmail connector
       * **refreshToken** - For Gmail connector
       * **gmailID** - For Gmail connector
       
2. Configure the callback url into github project webhook.
   * https://<server.public.ip>:<ballerina.port>/loan/callback
   
3. Send the loan request.
   * **Url:** https://<server.public.ip>:<ballerina.port>/loan/approve
   * **Content-type:** application/json
   * **payload:** {"amount": 100000, "customer": "wso2com@gmail.com"}
### Source Overview
[Souce overview](https://github.com/amalhub/state-dance/blob/master/resources/ApprovalService.svg)
