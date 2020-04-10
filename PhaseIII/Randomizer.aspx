<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Randomizer.aspx.cs" Inherits="PhaseIII.Randomizer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">

        .auto-style3 {
            font-size: large;
        }
        </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <strong><span class="auto-style3">Food Roulette</span><br class="auto-style3" />
            <br />
            <br />
            <br />
            <asp:Menu ID="Menu1" runat="server" BackColor="#E3EAEB" DynamicHorizontalOffset="2" Font-Names="Verdana" Font-Size="0.8em" ForeColor="#666666" Orientation="Horizontal" RenderingMode="Table" StaticSubMenuIndent="10px" Width="100%">
                <DynamicHoverStyle BackColor="#666666" ForeColor="White" />
                <DynamicMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
                <DynamicMenuStyle BackColor="#E3EAEB" />
                <DynamicSelectedStyle BackColor="#1C5E55" />
                <Items>
                    <asp:MenuItem NavigateUrl="~/Home.aspx" Text="Home" Value="Home"></asp:MenuItem>
                    <asp:MenuItem NavigateUrl="~/Randomizer.aspx" Text="Randomizer" Value="Randomizer"></asp:MenuItem>
                    <asp:MenuItem NavigateUrl="Restaurants.aspx" Text="Restaurants" Value="Restaurants"></asp:MenuItem>
                    <asp:MenuItem NavigateUrl="Reviews.aspx" Text="Reviews" Value="Reviews"></asp:MenuItem>
                </Items>
                <StaticHoverStyle BackColor="#666666" ForeColor="White" />
                <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
                <StaticSelectedStyle BackColor="#1C5E55" />
            </asp:Menu>
            <br />
            Select your search parameters and we will generate you a random restauraunt!</strong></div>
        <asp:DropDownList ID="City" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource2" DataTextField="Restaurant_City" DataValueField="Restaurant_City" onselectedindexchanged ="Restaurant_SelectedIndexChanged" ondatabound="City_DataBound">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT Restaurant_City FROM RESTAURANT_LOCATION"></asp:SqlDataSource>
        <br />
        <br />
        <asp:DropDownList ID="Cuisine" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource3" DataTextField="Cuisine_Type" DataValueField="Cuisine_Type" onselectedindexchanged ="Cuisine_SelectedIndexChanged" ondatabound="Cuisine_DataBound">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT [Cuisine_Type] FROM [CUISINE]"></asp:SqlDataSource>
        <br />
        <br />
        <asp:DropDownList ID="Rating" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource1" DataTextField="User_Rating" DataValueField="User_Rating"  onselectedindexchanged ="Rating_SelectedIndexChanged" ondatabound="Rating_DataBound">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT User_Rating
FROM SITE_REVIEW"></asp:SqlDataSource>
        <br />
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server">
        </asp:GridView>
    </form>
</body>
</html>
