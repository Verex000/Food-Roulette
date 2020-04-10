using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;


namespace PhaseIII
{
    public partial class Randomizer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Cuisine.Enabled = false;
            Rating.Enabled = false;
        }

        protected void Restaurant_SelectedIndexChanged(object sender, EventArgs e)
        {
            City.Enabled = false;
            Cuisine.Enabled = true;
        }

        protected void Cuisine_SelectedIndexChanged(object sender, EventArgs e)
        {
            Cuisine.Enabled = false;
            Rating.Enabled = true;

        }

        protected void Rating_SelectedIndexChanged(object sender, EventArgs e)
        {
            Rating.Enabled = false;
            City.Enabled = true;
            executeTheGrid();
            City.SelectedIndex = 0;
            Rating.SelectedIndex = 0;
            Cuisine.SelectedIndex = 0;

            
        }

        protected void executeTheGrid()
        {
            SqlConnection con = new SqlConnection(@"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\FoodRoulette.mdf;Integrated Security=True");
            con.Open();
            SqlCommand cmd = new SqlCommand(@"SELECT TOP 1 RESTAURANT.Restaurant_Name, RESTAURANT.Rating, RESTAURANT_LOCATION.Restaurant_Street, RESTAURANT_LOCATION.Restaurant_City
                                                FROM dbo.RESTAURANT, dbo.CUISINE, dbo.RESTAURANT_LOCATION
                                                  WHERE RESTAURANT.Restaurant_Id = CUISINE.Restaurant_Id and CUISINE.Cuisine_Type = '" + Cuisine.SelectedValue + @"' AND
                                                   RESTAURANT.Restaurant_Id = RESTAURANT_LOCATION.Restaurant_Id AND RESTAURANT_LOCATION.Restaurant_City = '" + City.SelectedValue + @"'
                                                    AND RESTAURANT.Restaurant_Id = ANY(SELECT Restaurant_Id
                                                                FROM RESTAURANT
                                                                WHERE RATING >= " + Convert.ToDouble(Rating.SelectedItem.Value) + @")
                                                    ORDER BY NEWID()", con);
            SqlDataReader rdr = cmd.ExecuteReader();
            GridView1.DataSource = rdr;
            GridView1.DataBind();
            con.Close();
        }

        protected void City_DataBound(object sender, EventArgs e)
        {
            City.Items.Insert(0, new ListItem(" -Select City- ", "0"));
        }

        protected void Rating_DataBound(object sender, EventArgs e)
        {
            Rating.Items.Insert(0, new ListItem("--Select Lowest Acceptable Rating--", "0"));
        }

        protected void Cuisine_DataBound(object sender, EventArgs e)
        {
            Cuisine.Items.Insert(0, new ListItem("--Select Food Type--", "0"));
        }


    }


}