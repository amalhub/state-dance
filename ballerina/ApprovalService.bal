import ballerina.net.http;
import ballerina.lang.messages;
import ballerina.lang.jsons;
import ballerina.lang.system;
import ballerina.lang.strings;
import org.wso2.ballerina.connectors.gmail;
@http:config {basePath:"/loan"}
service<http> Loan {

    string loanOfficer = "amalhub";
    string title = "Loan Approval";
    string git = "https://api.github.com/repos/amalhub/test";
    int reqID = 0;
    string clientID = "950873390542-h4fovl5ittjiahdtidnufktbvt4g41ad.apps.googleusercontent.com";
    string clientSecret = "yxuIv0TG1W8k5cTZScOMmV_s";
    string accessToken = "ya29.Glt7BK54qld2TZiqiA0CQPrBFhfpkkuSK0T5hhppqsDBBnqeq525SFKVbBRijZUGHvYuBeSPNhA8JfMOfWH8BCWRSBMFWN34S7ShCpBSBVpeDY83kLMWiWEBNP8D";
    string refreshToken = "1/GO3S0tNwtSYy_-qNcEb-ndHMbhY29bBb_guWaAO2s0M";
    string gmailID = "amalg@wso2.com";
    @http:POST {}
    @http:Path { value: "/approve"}
    resource Approve (message m) {
        http:ClientConnector gitEP = create http:ClientConnector (git);
        json payloadJson = messages:getJsonPayload(m);
        int amount = jsons:getInt(payloadJson,"$.amount");
        string customer = jsons:getString(payloadJson,"$.customer");
        string des = "Customer = " + customer + " \n Loan amount = " + amount + " LKR \n\n Please approve the loan. \n\n  If approved close ticket with comment \"approved\" else \"disapproved\".";
        json reqJson = {"title":"t","body":"","assignee":"a","labels":["loan"]};
        jsons:set(reqJson,"$.title",title);
        jsons:set(reqJson,"$.body",des);
        jsons:set(reqJson,"$.assignee",loanOfficer);
        string s = jsons:getString(reqJson,"$.title");
        message request = {};
        messages:setJsonPayload(request,reqJson);
        messages:addHeader(request,"Content-type","application/json");
        messages:addHeader(request,"Authorization","token 3660d6ad0fc9f1307dde39807a830cf0ae47e7e6");
        message result = http:ClientConnector.post(gitEP, "/issues", request);
        json resultJ = messages:getJsonPayload(result);
        reqID   = reqID + jsons:getInt(resultJ,"$.number");
        json responseJ = {"requestID": reqID};
        message response = {};
        messages:setJsonPayload(response,responseJ);
        http:convertToResponse(response);
        system:println("Task created with ID: " + reqID);
        reply response;
    }

    @http:POST {}
    @http:Path { value: "/callback"}
    resource callback (message m) {
        gmail:ClientConnector gmailConn = create gmail:ClientConnector (gmailID, accessToken, refreshToken, clientID, clientSecret);
        json payloadJson = messages:getJsonPayload(m);
        string description = jsons:getString(payloadJson,"$.issue.body");
        string comment = jsons:getString(payloadJson,"$.comment.body");
        string[] s = strings:split(description,"\n");
        string customer = strings:subString(s[0],11,strings:length(s[0])-1);
        string amount = strings:subString(s[1],15,strings:length(s[1])-1);
        message gmailResp = {};
        if (strings:equalsIgnoreCase(comment,"approved")) {
            string subject = "Loan request approved";
            string body = "Dear customer,\n\nWe are pleased to inform you that, your " + amount + " loan has been approved.\n\nRegards,\nFinance department.";
            gmailResp  = gmail:ClientConnector.sendMail(gmailConn, customer, subject, "", body, "", "", "", "");
        } else {
            string subject = "Loan request disapproved";
            string body = "Dear customer,\n\nWe are sorry to inform you that, your " + amount + " loan has been disapproved.\n\nRegards,\nFinance department.";
            gmailResp  = gmail:ClientConnector.sendMail(gmailConn, customer, subject, "", body, "", "", "", "");
        }
        system:println("Email sent to: " + customer);
        http:convertToResponse(gmailResp);
        reply gmailResp;
    }
}
