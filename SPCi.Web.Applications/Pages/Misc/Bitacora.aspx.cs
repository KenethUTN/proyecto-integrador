using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Telerik.Web.UI;

namespace SPCi.Web.Applications.Pages.Misc
{
    public partial class Bitacora : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RadGrid1.Rebind();
            }
            RadGrid1.ItemCommand += RadGrid1_ItemCommand;
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            if (RadGrid1 != null)
            {
                MostrarDatos();
            }
        }

        protected void MostrarDatos()
        {
            // Solo muestra datos si RadGrid1 no es null
            if (RadGrid1 != null)
            {
                string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM SGBitacora";
                    SqlDataAdapter dataAdapter = new SqlDataAdapter(query, connection);
                    DataTable dataTable = new DataTable();
                    dataAdapter.Fill(dataTable);
                    RadGrid1.DataSource = dataTable;
                }
            }
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "RebindGrid")
            {
                // Volver a enlazar los datos con RadGrid1
                RadGrid1.Rebind();
            }
        }

        protected void btnRedirect_Click(object sender, EventArgs e)
        {
            // Redirige a la página Bitacora.aspx
            Response.Redirect("Pruebas.aspx");
        }
    }
}
