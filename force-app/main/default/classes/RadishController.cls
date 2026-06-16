public with sharing class RadishController {
    public String badval1 { get; set; }
    public String badval2 { get; set; }

    public RadishController() {
        this.badval1 = 'Default value of badval1';
    }

    public Pagereference search1() {
        System.debug('search1 called');

        // At this point, the variable badval is bound to the <apex:inputText> element
        // in the VF page.  So it contains data from the user; we shouldn't trust it 
        // inside a query.  

        String qstr = 'SELECT Name, BillingStreet From Account where Name like \'%' + badval1 + '%\' ';
        List<Account> objs = database.query(qstr);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Retrieved ' + objs.size()));

        integer count = database.countQuery('SELECT count() From Account where Name like \'%' + badval1 + '%\' ');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Retrieved ' + count + ' via countQuery'));
        return null;
    }
    public Pagereference search2() {
        System.debug('search2 called');


        String idval = this.badval1;
        String sobjname = this.badval2;
        List<Account> nameobjs = Database.query('SELECT Name From ' + sobjname + ' where ID = \'' + idval + '\'');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'nameobjs ' + nameobjs.size()));

        String sstr = 'FIND \'*' + this.badval2 + '*\' IN ALL FIELDS RETURNING Account (Id, Name, BillingStreet)';
        List<Search.SearchResult> sr = Search.find(sstr).get('Account');
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Found ' + sr.size()));

        String querystr = 'FIND \'*' + this.badval2 + '*\' IN ALL FIELDS RETURNING Account (Id, Name, BillingStreet)';
        integer qsz = Search.query(querystr).size();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Found ' + qsz + ' via Search.query'));

        String suggeststr = 'FIND \'*' + this.badval2 + '*\' IN ALL FIELDS RETURNING Account (Id, Name, BillingStreet)';
        integer ssz = Search.suggest(suggeststr, 'Account', new Search.SuggestionOption()).getSuggestionResults().size();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Found ' + ssz + ' via Search.suggest'));
        return null;

    }
}
