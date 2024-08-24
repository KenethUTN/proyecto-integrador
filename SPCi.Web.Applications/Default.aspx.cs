using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using System.Data.SqlClient;

namespace SPCi.Web.Applications{
public partial class Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RadGrid2.Rebind();
            }
            RadGrid2.ItemCommand += RadGrid1_ItemCommand;
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            if (RadGrid2 != null)
            {
                MostrarDatos();
            }
        }

        protected void MostrarDatos()
        {
            // Solo muestra datos si RadGrid1 no es null
            if (RadGrid2 != null)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM op_camion_chofer";
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(query, connection);
                    DataTable dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    RadGrid2.DataSource = dataTable;
                }
            }
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "RebindGrid")
            {
                // Volver a enlazar los datos con RadGrid1
                RadGrid2.Rebind();
            }
        }

        protected void btnRedirect_Click(object sender, EventArgs e)
        {
            // Redirige a la página Bitacora.aspx
            Response.Redirect("Pruebas.aspx");
        }
    }

}
