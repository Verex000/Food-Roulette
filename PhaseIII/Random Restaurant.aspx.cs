using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PhaseIII
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DropDownList2.Enabled = false;
            Rating.Enabled = false;
        }



        protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList1.Enabled = false;
            Rating.Enabled = true;
        }

        protected void Rating_SelectedIndexChanged(object sender, EventArgs e)
        {
            Rating.Enabled = false;
            DropDownList2.Enabled = true;
        }

        protected void DropDownList3_SelectedIndexChange(object sender, EventArgs e)
        {
            DropDownList2.Enabled = false;
        }

    }
}