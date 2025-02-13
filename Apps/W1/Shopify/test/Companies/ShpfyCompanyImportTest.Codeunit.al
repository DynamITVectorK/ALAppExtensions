codeunit 139647 "Shpfy Company Import Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryAssert: Codeunit "Library Assert";
        CompanyImport: Codeunit "Shpfy Company Import";

    [Test]
    procedure UnitTestFindMappingBetweenCompanyAndCustomer()
    var
        Customer: Record Customer;
        ShopifyCompany: Record "Shpfy Company";
        ShopifyCustomer: Record "Shpfy Customer";
        Shop: Record "Shpfy Shop";
        InitializeTest: Codeunit "Shpfy Initialize Test";
        Result: Boolean;
    begin
        // [SCENARIO] Importing a company record that is already mapped to a customer record via email.
        Shop := InitializeTest.CreateShop();
        Shop."B2B Enabled" := true;

        // [GIVEN] Shop, Shopify company and Shopify customer
        CompanyImport.SetShop(Shop);
        ShopifyCompany.Insert();
        Customer.SetFilter("E-Mail", '<>%1', '');
        Customer.FindFirst();
        ShopifyCustomer.Email := Customer."E-Mail";


        // [WHEN] Invoke ShpfyCustomerImport.FindMapping(ShopifyCompany, ShopifyCustomer)
        Result := CompanyImport.FindMapping(ShopifyCompany, ShopifyCustomer);

        // [THEN] The result is true and Shopify company has the correct customer id.
        LibraryAssert.IsTrue(Result, 'Result');
        LibraryAssert.AreEqual(ShopifyCompany."Customer SystemId", Customer.SystemId, 'Customer SystemId');
    end;
}