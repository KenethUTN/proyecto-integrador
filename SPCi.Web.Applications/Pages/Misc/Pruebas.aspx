<%@ Page Title="" Language="C#" MasterPageFile="~/Shared/MasterPages/RLSiteMenu.Master" AutoEventWireup="true" CodeBehind="Pruebas.aspx.cs" Inherits="SPCi.Web.Applications.Pages.Misc.Pruebas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadPageLayout runat="server" ID="JumbotronLayout" CssClass="jumbotron" GridType="Fluid">
        <Rows>
            <telerik:LayoutRow>
                <Columns>
                    <telerik:LayoutColumn Span="10" SpanMd="12" SpanSm="12" SpanXs="12">
                    </telerik:LayoutColumn>
                </Columns>
            </telerik:LayoutRow>
        </Rows>
    </telerik:RadPageLayout>

    <asp:Button ID="btnRefresh" runat="server" Text="Cargar por Excel" OnClick="btnRefresh_Click"  />
    <asp:Button ID="btnRedirect" runat="server" Text="Bitacora" OnClick="btnRedirect_Click" />
    <asp:Button ID="btnEnviar" runat="server" Text="Enviar Formulario" OnClick="btnEnviar_Click" />
    
    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" CssClass="grid_wrapper">
        <telerik:RadGrid ID="RadGrid1" runat="server" PageSize="10" PagerStyle-PageButtonCount="5"
            OnNeedDataSource="RadGrid1_NeedDataSource" AllowPaging="True" AllowSorting="true" ShowGroupPanel="True" ShowGroupPanelText= "Arrastre una columna para agrupar" RenderMode="Auto" Width="100%" Height="500px">
            <GroupingSettings ShowUnGroupButton="true" />
            <ExportSettings ExportOnlyData="true" IgnorePaging="true"></ExportSettings>
            <MasterTableView AutoGenerateColumns="False"
                AllowFilteringByColumn="True" TableLayout="Fixed"
                DataKeyNames="lx_SGTemporal" CommandItemDisplay="Top"
                InsertItemPageIndexAction="ShowItemOnFirstPage">
                <CommandItemSettings ShowExportToCsvButton="true" ShowExportToExcelButton="true" ShowExportToPdfButton="true" ShowExportToWordButton="true" AddNewRecordText="Formulario" RefreshText="Actualizar"/>
                <Columns>
                    <telerik:GridTemplateColumn HeaderText="ID Vista" UniqueName="lx_SGTemporal">
                        <HeaderStyle Width="150px" />
                        <ItemTemplate>
                            <asp:Label ID="lblIdVista" runat="server" Text='<%# Eval("lx_SGTemporal") %>' />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="lblIdVistaEdit" runat="server" Text='<%# Bind("lx_SGTemporal") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:Label ID="lblIdVistaInsert" runat="server" Text='<%# SiguienteIdVista %>' />
                        </InsertItemTemplate>
                    </telerik:GridTemplateColumn>
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
                    <telerik:GridTemplateColumn HeaderText="Fecha" UniqueName="fecha_hora">
                        <HeaderStyle Width="150px" />
                        <ItemTemplate>
                            <asp:Label ID="lblFechaHora" runat="server" Text='<%# Eval("fecha_hora") %>' />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="lblFechaHoraEdit" runat="server" Text='<%# Bind("fecha_hora") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:Label ID="lblFechaHoraInsert" runat="server" Text='<%# DateTime.Now.ToString("G") %>' />
                        </InsertItemTemplate>
                    </telerik:GridTemplateColumn>   
                    <telerik:GridTemplateColumn HeaderText="Estado" UniqueName="estado">
                        <ItemTemplate>
                            <asp:Label ID="lblEstado" runat="server" 
                                Text='<%# Convert.ToBoolean(Eval("estado")) ? "✔" : "✘" %>' />
                        </ItemTemplate>
                        <HeaderStyle Width="50px" />
                    </telerik:GridTemplateColumn>
                    <telerik:GridEditCommandColumn UniqueName="EditColumn" HeaderText="Editar">
                        <HeaderStyle Width="70px" />
                    </telerik:GridEditCommandColumn>
                    <telerik:GridButtonColumn CommandName="BorrarEnBD" Text="✘" UniqueName="DeleteColumn" HeaderText="Eliminar"
                        ConfirmText="¿Está seguro que desea eliminar este registro?" ConfirmDialogType="RadWindow"
                        ConfirmTitle="Confirmación de eliminación">
                        <HeaderStyle Width="70px" />
                    </telerik:GridButtonColumn>
                </Columns>

            </MasterTableView>
            <ClientSettings AllowColumnsReorder="true" AllowColumnHide="true" AllowDragToGroup="true">
                <Selecting AllowRowSelect="true" />
                <Scrolling AllowScroll="true" UseStaticHeaders="true" />
            </ClientSettings>
        </telerik:RadGrid>
    </telerik:RadAjaxPanel>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
    <AjaxSettings>
        <telerik:AjaxSetting AjaxControlID="btnRefresh">
            <UpdatedControls>
                <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
            </UpdatedControls>
        </telerik:AjaxSetting>
    </AjaxSettings>
</telerik:RadAjaxManager>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>

