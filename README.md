# State Dance Project (powered by WSO2 Ballerina)

The following project is desinged to create **User Tasks** in **Ballerina** using Github issues for asynchronous service orchestrations.
![Architecture diagram](https://github.com/amalhub/state-dance/blob/master/resources/state-dance-diagram.png "Architecture diagram")
The project demonstrates a customer sending a loan approval request and Ballerina will create a User task (git issue) in github assigning it to the loan officer for approval. Once the loan officer responds to the task, Github webhook will invoke the Bellerina callback service. Depending on the approval/disapproval, an email will get sent back to the respective customer. 

### How to run
1. Download and deploy the **/ballerina/ApprovalService.bal** file in [Ballerina server](https://ballerinalang.org/).
   * Make sure to update the configurations.
       * **loanOfficer** - Github account user id
       * **git** - Github url
       * **clientID** - For Gmail connector
       * **clientSecret** - For Gmail connector
       * **accessToken** - For Gmail connector
       * **refreshToken** - For Gmail connector
       * **gmailID** - For Gmail connector
       
2. Configure the callback url into github project webhook.
   * Goto https://github.com/{user}/{project}/settings/hooks
   * Click on **Add new Webhook**
   * Enter the callback url as the payload url
      * http://{server.public.ip}:{ballerina.port}/loan/callback
   * **Content-type:** application/json
   * Under event triggers, select option **"Let me select individual events"** and then tick only **"Issue comment"** option.
   * Finally click on **Add Webhook** button.
   
3. Send the loan request.
   * **Url:** http://{server.public.ip}:{ballerina.port}/loan/approve
   * **Content-type:** application/json
   * **payload:** {"amount": 100000, "customer": "amalg@wso2.com"}
### Source Overview
  * [Diagram](https://github.com/amalhub/state-dance/blob/master/resources/ApprovalService.svg)
  
### Future enhancements
  * If there are any data that needs to be persisted and correlated, using **ballerina.data.sql** we can persist data with an id and when the callback service triggers back with the id, we can retrieve the persisted data back. (Correlation)
