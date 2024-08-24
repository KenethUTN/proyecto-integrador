using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.TextBased.Csv;
using Telerik.Windows.Documents.Spreadsheet.Formatting.FormatStrings;
using Telerik.Windows.Documents.Spreadsheet.Model;
using System.Configuration;

namespace SPCi.Web.Applications.Pages.Misc
{
    public partial class Excel : System.Web.UI.Page
    {
        public string almacenamientoFisico;
        private Workbook workbook;
        private IWorkbookFormatProvider fileFormatProvider;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnCargar_Click(object sender, EventArgs e)
        {
            CargarArchivo();
            grdCargarDesdeExcelTMP.Rebind();
        }

        public static SqlConnection MiConexion(string NombreConexion)
        {
            SqlConnection conexion;
            try
            {
                conexion = new SqlConnection(ConfigurationManager.ConnectionStrings[NombreConexion].ToString());
            }
            catch
            {
                conexion = null;
            }
            return conexion;
        }

        public static IWorkbookFormatProvider GetFormatProvider(string extension)
        {
            IWorkbookFormatProvider formatProvider;
            switch (extension)
            {
                case ".xlsx":
                    formatProvider = new XlsxFormatProvider();
                    break;
                case ".csv":
                    formatProvider = new CsvFormatProvider();
                    ((CsvFormatProvider)formatProvider).Settings.HasHeaderRow = true;
                    break;
                default:
                    formatProvider = null;
                    break;
            }

            return formatProvider;
        }

        protected void CargarArchivo()
        {
            almacenamientoFisico = "D:\\Temporal\\";
            txtResultado.Text = "";
            int id;
            bool res;

            if (aulArchivo.UploadedFiles.Count > 0)
            {
                foreach (Telerik.Web.UI.UploadedFile postedFile in aulArchivo.UploadedFiles)
                {
                    if (!Object.Equals(postedFile, null))
                    {
                        if (postedFile.ContentLength > 0)
                        {
                            string nombreArchivo = Path.GetFileName(postedFile.FileName);
                            string rutaArchivo = almacenamientoFisico + System.Guid.NewGuid().ToString() + "-" + nombreArchivo;
                            try
                            {
                                postedFile.SaveAs(rutaArchivo, true);
                                fileFormatProvider = GetFormatProvider(postedFile.GetExtension());
                                using (FileStream input = new FileStream(rutaArchivo, FileMode.Open))
                                {
                                    workbook = fileFormatProvider.Import(input);
                                }

                                Worksheet worksheet = (Worksheet)workbook.Sheets[0];
                                if (worksheet.Name == "Contenedores")
                                {
                                    if (worksheet.UsedCellRange.ColumnCount >= 5) // Ahora se requieren solo 5 columnas
                                    {
                                        for (int i = 1; i < worksheet.UsedCellRange.RowCount; i++)
                                        {
                                            var values = new object[worksheet.UsedCellRange.ColumnCount];

                                            for (int j = 0; j < worksheet.UsedCellRange.ColumnCount; j++)
                                            {
                                                CellSelection selection = worksheet.Cells[i, j];
                                                ICellValue value = selection.GetValue().Value;
                                                CellValueFormat format = selection.GetFormat().Value;
                                                CellValueFormatResult formatResult = format.GetFormatResult(value);
                                                string result = formatResult.InfosText;
                                                values[j] = result;
                                            }

                                            res = int.TryParse(values[0].ToString(), out id);
                                            if (res)
                                            {
                                                using (SqlConnection conexion = MiConexion("op_SPC"))
                                                {
                                                    using (SqlCommand cmd = new SqlCommand("AgregarCargarDesdeExcelTMP", conexion))
                                                    {
                                                        cmd.CommandType = CommandType.StoredProcedure;

                                                        cmd.Parameters.Add("@lx_ServicioGranel", SqlDbType.Int).Value = Convert.ToInt32(values[0]);
                                                        // Eliminamos el parámetro @idCliente
                                                        cmd.Parameters.Add("@idTipoCarga", SqlDbType.Int).Value = Convert.ToInt32(values[1]);
                                                        cmd.Parameters.Add("@cho_cedula", SqlDbType.VarChar).Value = values[2].ToString();
                                                        cmd.Parameters.Add("@cam_placa", SqlDbType.VarChar).Value = values[3].ToString();

                                                        conexion.Open();
                                                        cmd.ExecuteNonQuery();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        txtResultado.Text = "El archivo cargado no tiene la estructura requerida, la hoja no tiene las columnas requeridas.";
                                        return;
                                    }
                                }
                                else
                                {
                                    txtResultado.Text = "El archivo cargado no tiene la estructura requerida, la hoja debe llamarse Personal.";
                                    return;
                                }
                            }
                            catch (Exception ex)
                            {
                                txtResultado.Text = "No se puedo cargar el archivo: " + ex.Message;
                                return;
                            }
                        }
                        else
                        {
                            txtResultado.Text = "No se cargó ningún archivo.";
                        }
                    }
                    else
                    {
                        txtResultado.Text = "No se cargó ningún archivo.";
                    }
                }
            }
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            string usuario = UserLog;

            using (SqlConnection conexion = new SqlConnection(ConfigurationManager.ConnectionStrings["op_SPC"].ConnectionString))
            {
                try
                {
                    conexion.Open();

                    using (SqlCommand cmd = new SqlCommand("CopiarDatosDesdeTemporal", conexion))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@Usuario", usuario);
                        cmd.ExecuteNonQuery();
                        txtResultado.Text = "Datos copiados exitosamente con estado 1.";
                    }

                    using (SqlCommand cmdBitacora = new SqlCommand("INSERT INTO SGBitacora (fecha_hora, Usuario, Accion, Tabla, Registro) VALUES (GETDATE(), @Usuario, 'EXCEL', 'Vista', @Registro)", conexion))
                    {
                        cmdBitacora.Parameters.AddWithValue("@Usuario", UserLog);
                        cmdBitacora.Parameters.AddWithValue("@Registro", Registro);
                        cmdBitacora.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    txtResultado.Text = "No se pudo realizar la operación: " + ex.Message;
                }
                finally
                {
                    if (conexion.State == ConnectionState.Open)
                    {
                        conexion.Close();
                    }
                }
            }

            Response.Redirect("Pruebas.aspx");
        }

        string UserLog = "Keneth";
        int Registro = 99;

        protected void btnRedirect_Click(object sender, EventArgs e)
        {
            // Redirige a la página Bitacora.aspx
            Response.Redirect("Pruebas.aspx");
        }
    }

    
}
