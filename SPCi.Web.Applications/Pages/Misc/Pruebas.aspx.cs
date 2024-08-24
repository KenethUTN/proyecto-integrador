using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Telerik.Web.UI;

namespace SPCi.Web.Applications.Pages.Misc
{
    public partial class Pruebas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EjecutarProcedimientoActualizarEstadoVista();
                RadGrid1.Rebind();
            }
            RadGrid1.ItemCommand += RadGrid1_ItemCommand;
            RadGrid1.UpdateCommand += RadGrid1_UpdateCommand;
            RadGrid1.InsertCommand += RadGrid1_InsertCommand; // Agregar el evento de inserción
        }

        private DataTable ObtenerDatos()
        {
            DataTable dataTable = new DataTable();
            string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        t.lx_SGTemporal,
                        t.lx_ServicioGranel,
                        t.idTipoCarga,
                        t.cho_cedula,
                        t.cam_placa,
                        t.fecha_hora,
                        t.estado,
                        c.DsTipoCarga AS TipoCargaNombre,
                        s.DsServicioGranel AS ServicioGranelNombre
                    FROM
                        dbo.SGTemporal t
                    INNER JOIN
                        dbo.VCarga c ON t.idTipoCarga = c.IdTipoCargo
                    INNER JOIN
                        dbo.ServicioGranel s ON t.lx_ServicioGranel = s.IxServicioGranel";

                SqlDataAdapter dataAdapter = new SqlDataAdapter(query, connection);
                dataAdapter.Fill(dataTable);
            }
            return dataTable;
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid1.DataSource = ObtenerDatos();
        }

        private void EjecutarProcedimientoActualizarEstadoVista()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("ActualizarEstadoSGTemporal", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            // Redirigir a la página AgregarDesdeExcel.aspx
            Response.Redirect("Excel.aspx");
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "RebindGrid")
            {
                // Ejecutar el procedimiento almacenado para actualizar los datos
                EjecutarProcedimientoActualizarEstadoVista();

                // Volver a enlazar los datos con RadGrid1
                RadGrid1.Rebind();
            }

            if (e.CommandName == "BorrarEnBD")
            {
                // Asegúrate de que el elemento del comando es un GridDataItem
                GridDataItem dataItem = e.Item as GridDataItem;
                if (dataItem != null)
                {
                    // Obtén el valor del ID de la fila seleccionada
                    int id = Convert.ToInt32(dataItem.GetDataKeyValue("lx_SGTemporal"));

                    // Llama al método para borrar el registro de la base de datos
                    BorrarEnBD(id);

                    // Actualiza el grid
                    RadGrid1.Rebind();
                }
            }
        }

        private void BorrarEnBD(int id)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand("EliminarRegistroYRegistrarBitacora", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Id", id);
                    command.Parameters.AddWithValue("@Usuario", UserLog); // Obtener el usuario actual del entorno

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem editedItem = e.Item as GridEditableItem;
            int id = Convert.ToInt32(editedItem.GetDataKeyValue("lx_SGTemporal"));

            // Obtén los nuevos valores de las columnas usando GridTextBoxColumnEditor
            var servicioGranelEditor = (GridTextBoxColumnEditor)editedItem.EditManager.GetColumnEditor("lx_ServicioGranel");
            int lx_ServicioGranel = Convert.ToInt32(servicioGranelEditor.TextBoxControl.Text);

            var tipoCargaEditor = (GridTextBoxColumnEditor)editedItem.EditManager.GetColumnEditor("idTipoCarga");
            int idTipoCarga = Convert.ToInt32(tipoCargaEditor.TextBoxControl.Text);

            var cedulaEditor = (GridTextBoxColumnEditor)editedItem.EditManager.GetColumnEditor("cho_cedula");
            string cho_cedula = cedulaEditor.TextBoxControl.Text;

            var placaEditor = (GridTextBoxColumnEditor)editedItem.EditManager.GetColumnEditor("cam_placa");
            string cam_placa = placaEditor.TextBoxControl.Text;
            bool estado = true;

            // Llama al método para actualizar el registro
            EditarEnBD(id, lx_ServicioGranel, idTipoCarga, cho_cedula, cam_placa, estado);

            // Reenlaza los datos al grid
            RadGrid1.Rebind();
        }

        private void EditarEnBD(int id, int lx_ServicioGranel, int idTipoCarga, string cho_cedula, string cam_placa, bool estado)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    // Usar el procedimiento almacenado para actualizar el registro y registrar la bitácora
                    using (SqlCommand command = new SqlCommand("ActualizarRegistroYRegistrarBitacora", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Añadir parámetros del procedimiento almacenado
                        command.Parameters.AddWithValue("@Id", id);
                        command.Parameters.AddWithValue("@ServicioGranel", lx_ServicioGranel);
                        command.Parameters.AddWithValue("@TipoCarga", idTipoCarga);
                        command.Parameters.AddWithValue("@Cedula", cho_cedula);
                        command.Parameters.AddWithValue("@Placa", cam_placa);
                        command.Parameters.AddWithValue("@Estado", estado);
                        command.Parameters.AddWithValue("@Usuario", UserLog);

                        // Abrir conexión y ejecutar el procedimiento almacenado
                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    // Manejar excepciones y mostrar mensaje de error
                    Console.WriteLine("Error al ejecutar el procedimiento almacenado: " + ex.Message);
                }
            }
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormInsertItem insertItem = e.Item as GridEditFormInsertItem;
            if (insertItem != null)
            {
                // Obtén los valores de los campos del formulario de inserción
                var servicioGranelEditor = (GridTextBoxColumnEditor)insertItem.EditManager.GetColumnEditor("lx_ServicioGranel");
                int lx_ServicioGranel = Convert.ToInt32(servicioGranelEditor.TextBoxControl.Text);

                var tipoCargaEditor = (GridTextBoxColumnEditor)insertItem.EditManager.GetColumnEditor("idTipoCarga");
                int idTipoCarga = Convert.ToInt32(tipoCargaEditor.TextBoxControl.Text);

                var cedulaEditor = (GridTextBoxColumnEditor)insertItem.EditManager.GetColumnEditor("cho_cedula");
                string cho_cedula = cedulaEditor.TextBoxControl.Text;

                var placaEditor = (GridTextBoxColumnEditor)insertItem.EditManager.GetColumnEditor("cam_placa");
                string cam_placa = placaEditor.TextBoxControl.Text;

                bool estado = true;

                // Llama al método para insertar el nuevo registro
                InsertarEnBD(lx_ServicioGranel, idTipoCarga, cho_cedula, cam_placa, estado);

                // Reenlaza los datos al grid
                RadGrid1.Rebind();
                EjecutarProcedimientoActualizarEstadoVista();
            }
        }
        private void InsertarEnBD(int lx_ServicioGranel, int idTipoCarga, string cho_cedula, string cam_placa, bool estado)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    // Usar el procedimiento almacenado para insertar el registro y registrar la bitácora
                    using (SqlCommand command = new SqlCommand("InsertarRegistroYRegistrarBitacora", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Añadir parámetros del procedimiento almacenado
                        command.Parameters.AddWithValue("@ServicioGranel", lx_ServicioGranel);
                        command.Parameters.AddWithValue("@TipoCarga", idTipoCarga);
                        command.Parameters.AddWithValue("@Cedula", cho_cedula);
                        command.Parameters.AddWithValue("@Placa", cam_placa);
                        command.Parameters.AddWithValue("@Estado", estado);
                        command.Parameters.AddWithValue("@Usuario", UserLog);

                        // Abrir conexión y ejecutar el procedimiento almacenado
                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    // Manejar excepciones y mostrar mensaje de error
                    Console.WriteLine("Error al ejecutar el procedimiento almacenado: " + ex.Message);
                }
            }
        }

        // Metodo para obtener ID  
        public int SiguienteIdVista
        {
            get
            {
                return ObtenerSiguienteIdVista();
            }
        }

        protected int ObtenerSiguienteIdVista()
        {
            int siguienteId = 1; // Valor predeterminado si no hay registros

            string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT ISNULL(MAX(lx_SGTemporal), 0) + 1 FROM SGTemporal";
                SqlCommand command = new SqlCommand(query, connection);
                connection.Open();
                siguienteId = (int)command.ExecuteScalar();
            }

            return siguienteId;
        }

        protected void btnRedirect_Click(object sender, EventArgs e)
        {
            // Redirige a la página Bitacora.aspx
            Response.Redirect("Bitacora.aspx");
        }

        //logica para inicio de sesion
        string UserLog = "Keneth";

        protected void btnEnviar_Click(object sender, EventArgs e)
    {

        string connectionString = ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString;

        string procedureCopyAndDelete = "CopiarYEliminarDatosDesdeSGTemporal";

        string procedureLog = "RegistrarAutorizadosBitacora";

        string usuario = "Usuario"; 

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(procedureCopyAndDelete, connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        // Registrar la acción en la bitácora
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand(procedureLog, connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@Usuario", usuario);
                command.Parameters.AddWithValue("@Accion", "Insertar"); 
                command.Parameters.AddWithValue("@Tabla", "op_camion_chofer"); 
                command.Parameters.AddWithValue("@Registro", 98765); 

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        Response.Redirect("../../Default.aspx");
    }
        }
    
}

//cliente