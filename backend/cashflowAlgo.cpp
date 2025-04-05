#include<bits/stdc++.h>
using namespace std;

class Cashflow{
    public:
    int n;
    vector<vector<int>>adjMat;
    vector<int>totalBal;
    Cashflow(int n){
        this->n=n;
        adjMat.resize(n,vector<int>(n,0));
        totalBal.resize(n,0);
    }
    void addTransactions(int src,int dest,int amt){
        adjMat[src][dest]=amt;
    }
    void computeBalance(){
        for(int i=0;i<n;i++){
            for(int j=0;j<n;j++){
                totalBal[i]+=(adjMat[j][i]-adjMat[i][j]);
            }
        }
    }
    void minimizeTransactions(){
        priority_queue<pair<int,int>>creditors,debtors;
        for(int i=0;i<n;i++){
            if(totalBal[i]>0){
                creditors.push(make_pair(totalBal[i],i));
            }
            else if(totalBal[i]<0){
                debtors.push(make_pair(-totalBal[i],i));
            }
        }
        while(!creditors.empty() && !debtors.empty()){
            pair<int,int>creditor=creditors.top();
            creditors.pop();
            pair<int,int>debtor=debtors.top();
            debtors.pop();
            int credit=creditor.first;
            int cindex=creditor.second;
            int debt=debtor.first;
            int dindex=debtor.second;
            int settledAmt=min(credit,debt);
            cout<<"person "<<dindex<<"pays"<<settledAmt<<" to person"<<cindex<<endl;
            if(credit>debt){
                creditors.push({credit-debt,cindex});
            }
            else if(debt>credit){
                debtors.push(make_pair(debt-credit,dindex));
            }
        }
    }
};
