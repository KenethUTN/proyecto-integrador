<%@ Page Title="" Language="C#" MasterPageFile="~/Shared/MasterPages/RLSiteMenu.Master" AutoEventWireup="true" CodeBehind="Excel.aspx.cs" Inherits="SPCi.Web.Applications.Pages.Misc.Excel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <table>
  <tr>
   <td>
    <telerik:RadAsyncUpload ID="aulArchivo" runat="server" MaxFileInputsCount="1"
     AllowedFileExtensions=".xlsx" Localization-Select="Seleccionar"
     Localization-Remove="Quitar" Localization-Cancel="Cancelar"
     Localization-DropZone="Arrastre archivos aqui">
    </telerik:RadAsyncUpload>
   </td>
   <td>
    <telerik:RadPushButton ID="btnCargar" runat="server" Text="Cargar archivo"
     SingleClickText="Cargando..." SingleClick="True" OnClick="btnCargar_Click">
    </telerik:RadPushButton>
   </td>
  </tr>
 </table>

<asp:Button ID="btnRedirect" runat="server" Text="Formulario" OnClick="btnRedirect_Click" />

 <telerik:RadTextBox ID="txtResultado" runat="server" Width="100px"></telerik:RadTextBox>
 <telerik:RadGrid ID="grdCargarDesdeExcelTMP" runat="server" CellSpacing="-1" Culture="es-ES" DataSourceID="sdsCargarDesdeExcelTMP" GridLines="Both">
  <MasterTableView DataSourceID="sdsCargarDesdeExcelTMP" AutoGenerateColumns="False" DataKeyNames="IxCargarDesdeExcelTMP">
   <Columns>
        <telerik:GridBoundColumn DataField="lx_ServicioGranel" HeaderText="Servicio Granel" SortExpression="lx_ServicioGranel"
                        UniqueName="lx_ServicioGranel">
                        <HeaderStyle Width="150px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="idTipoCarga" HeaderText="Carga" SortExpression="idTipoCarga"
                        UniqueName="idTipoCarga">
                        <HeaderStyle Width="150px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="cho_cedula" HeaderText="Chofer" SortExpression="cho_cedula"
                        UniqueName="cho_cedula">
                        <HeaderStyle Width="150px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="cam_placa" HeaderText="Camión" SortExpression="cam_placa"
                        UniqueName="cam_placa">
                        <HeaderStyle Width="150px" />
                </telerik:GridBoundColumn>        
   </Columns>

  </MasterTableView>
 </telerik:RadGrid>
 <asp:Button ID="btnEnviar" runat="server" Text="Enviar" OnClick="btnEnviar_Click"
 ConfirmText="¿Está seguro que desea enviar estos datos?" ConfirmDialogType="RadWindow"
                        ConfirmTitle="Confirmación"/>
 <asp:SqlDataSource runat="server" ID="sdsCargarDesdeExcelTMP" 
    ConnectionString='<%$ ConnectionStrings:op_SPC %>' 
    SelectCommand="SELECT IxCargarDesdeExcelTMP, lx_ServicioGranel, idTipoCarga, cho_cedula, cam_placa 
                   FROM CargarDesdeExcelTMP_OP">
</asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>
