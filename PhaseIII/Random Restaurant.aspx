<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Random Restaurant.aspx.cs" Inherits="PhaseIII.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">

        .auto-style1 {
            text-align: center;
        }
        .auto-style3 {
            font-size: large;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        <div class="auto-style1">
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
                    <asp:MenuItem NavigateUrl="Restaurants.aspx" Text="Restaurants" Value="Restaurants"></asp:MenuItem>
                    <asp:MenuItem NavigateUrl="Reviews.aspx" Text="Reviews" Value="Reviews"></asp:MenuItem>
                </Items>
                <StaticHoverStyle BackColor="#666666" ForeColor="White" />
                <StaticMenuItemStyle HorizontalPadding="5px" VerticalPadding="2px" />
                <StaticSelectedStyle BackColor="#1C5E55" />
            </asp:Menu>
            <br />
            Select a category that for a random restaurant you would like</strong></div>
        </div>
        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource1" DataTextField="Cuisine_Type" DataValueField="Cuisine_Type" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT [Cuisine_Type] FROM [CUISINE]"></asp:SqlDataSource>
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="Restaurant_Id,Restaurant_Id1,Cuisine_Type" DataSourceID="SqlDataSource2">
            <Columns>
                <asp:BoundField DataField="Restaurant_Id" HeaderText="Restaurant_Id" ReadOnly="True" SortExpression="Restaurant_Id" />
                <asp:BoundField DataField="Restaurant_Name" HeaderText="Restaurant_Name" SortExpression="Restaurant_Name" />
                <asp:BoundField DataField="Phone_Number" HeaderText="Phone_Number" SortExpression="Phone_Number" />
                <asp:BoundField DataField="Rating" HeaderText="Rating" SortExpression="Rating" />
                <asp:BoundField DataField="Restaurant_Id1" HeaderText="Restaurant_Id1" ReadOnly="True" SortExpression="Restaurant_Id1" />
                <asp:BoundField DataField="Cuisine_Type" HeaderText="Cuisine_Type" ReadOnly="True" SortExpression="Cuisine_Type" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT TOP 1 * 
FROM dbo.RESTAURANT, dbo.CUISINE
WHERE RESTAURANT.Restaurant_Id = CUISINE.Restaurant_Id and CUISINE.Cuisine_Type = @Cuisine_Type
ORDER BY NEWID();
">
            <SelectParameters>
                <asp:ControlParameter ControlID="DropDownList1" Name="Cuisine_Type" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <p style="margin-bottom: 19px">
&nbsp;<asp:DropDownList ID="Rating" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource5" DataTextField="User_Rating" DataValueField="User_Rating" OnSelectedIndexChanged="Rating_SelectedIndexChanged">
            </asp:DropDownList>
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT User_Rating
FROM SITE_REVIEW"></asp:SqlDataSource>
        </p>
        <p style="margin-bottom: 19px">
            <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource6">
                <Columns>
                    <asp:BoundField DataField="Restaurant_Name" HeaderText="Restaurant_Name" SortExpression="Restaurant_Name" />
                    <asp:BoundField DataField="Rating" HeaderText="Rating" SortExpression="Rating" />
                    <asp:BoundField DataField="Restaurant_Street" HeaderText="Restaurant_Street" SortExpression="Restaurant_Street" />
                    <asp:BoundField DataField="Restaurant_City" HeaderText="Restaurant_City" SortExpression="Restaurant_City" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT TOP 1 Restaurant_Name, RESTAURANT.Rating, RESTAURANT_LOCATION.Restaurant_Street, RESTAURANT_LOCATION.Restaurant_City
FROM RESTAURANT, RESTAURANT_LOCATION
WHERE RESTAURANT.Restaurant_Id = RESTAURANT_LOCATION.Restaurant_Id and RESTAURANT.Restaurant_Id = ANY (SELECT Restaurant_Id
				FROM RESTAURANT
				WHERE RATING &gt;= @User_Rating)
ORDER BY NEWID();">
                <SelectParameters>
                    <asp:ControlParameter ControlID="Rating" Name="User_Rating" PropertyName="SelectedValue" />
                </SelectParameters>
            </asp:SqlDataSource>
        </p>
        <asp:DropDownList ID="DropDownList2" runat="server" AutoPostBack="True" DataSourceID="SqlDataSource3" DataTextField="Restaurant_City" DataValueField="Restaurant_City">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT DISTINCT Restaurant_City FROM RESTAURANT_LOCATION"></asp:SqlDataSource>
        <br />
        <br />
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource4" OnSelectedIndexChanged="GridView2_SelectedIndexChanged">
            <Columns>
                <asp:BoundField DataField="Restaurant_Name" HeaderText="Restaurant_Name" SortExpression="Restaurant_Name" />
                <asp:BoundField DataField="Phone_Number" HeaderText="Phone_Number" SortExpression="Phone_Number" />
                <asp:BoundField DataField="Rating" HeaderText="Rating" SortExpression="Rating" />
                <asp:BoundField DataField="Restaurant_Street" HeaderText="Restaurant_Street" SortExpression="Restaurant_Street" />
                <asp:BoundField DataField="Restaurant_City" HeaderText="Restaurant_City" SortExpression="Restaurant_City" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="SELECT TOP 1 RESTAURANT.Restaurant_Name, RESTAURANT.Phone_Number, RESTAURANT.Rating, RESTAURANT_LOCATION.Restaurant_Street, RESTAURANT_LOCATION.Restaurant_City
FROM dbo.RESTAURANT, dbo.RESTAURANT_LOCATION
WHERE RESTAURANT.Restaurant_Id = RESTAURANT_LOCATION.Restaurant_Id and RESTAURANT_LOCATION.Restaurant_City = @Restaurant_City
ORDER BY NEWID();
">
            <SelectParameters>
                <asp:ControlParameter ControlID="DropDownList2" Name="Restaurant_City" PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <p style="margin-bottom: 19px">
            &nbsp;</p>
    </form>
    <p style="margin-bottom: 19px">
&nbsp;&nbsp;&nbsp;
    </p>
</body>
</html>
