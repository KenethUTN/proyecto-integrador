<%@ Page Title="" Language="C#" MasterPageFile="~/Shared/MasterPages/RLSiteMenu.Master" AutoEventWireup="true" CodeBehind="Bitacora.aspx.cs" Inherits="SPCi.Web.Applications.Pages.Misc.Bitacora" %>
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

    <asp:Button ID="btnRedirect" runat="server" Text="Formulario" OnClick="btnRedirect_Click" />

    <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" CssClass="grid_wrapper">
        <telerik:RadGrid ID="RadGrid1" runat="server" PageSize="10" PagerStyle-PageButtonCount="5"
            OnNeedDataSource="RadGrid1_NeedDataSource" AllowPaging="True" AllowSorting="true" ShowGroupPanel="True" RenderMode="Auto" Width="100%" Height="500px">
            <GroupingSettings ShowUnGroupButton="true" />
            <ExportSettings ExportOnlyData="true" IgnorePaging="true"></ExportSettings>
            <MasterTableView AutoGenerateColumns="False"
                AllowFilteringByColumn="True" TableLayout="Fixed"
                DataKeyNames="lx_SGBitacora" CommandItemDisplay="Top"
                InsertItemPageIndexAction="ShowItemOnFirstPage">
                <CommandItemSettings ShowExportToCsvButton="true" ShowExportToExcelButton="true" ShowExportToPdfButton="true" ShowExportToWordButton="true" AddNewRecordText="Formulario" RefreshText="Actualizar"/>
                <Columns>

            <telerik:GridBoundColumn DataField="lx_SGBitacora" HeaderText="lx_SGBitacora" UniqueName="lx_SGBitacora">
                <HeaderStyle Width="150px" />
            </telerik:GridBoundColumn>
            
            <telerik:GridBoundColumn DataField="fecha_hora" HeaderText="fecha_hora" UniqueName="fecha_hora">
                <HeaderStyle Width="150px" />
                <ItemStyle Width="150px" />
            </telerik:GridBoundColumn>
            
            <telerik:GridBoundColumn DataField="Usuario" HeaderText="Usuario" UniqueName="Usuario">
                <HeaderStyle Width="150px" />
            </telerik:GridBoundColumn>
            
            <telerik:GridBoundColumn DataField="Accion" HeaderText="Accion" UniqueName="Accion">
                <HeaderStyle Width="150px" />
            </telerik:GridBoundColumn>
            
            <telerik:GridBoundColumn DataField="Tabla" HeaderText="Tabla" UniqueName="Tabla">
                <HeaderStyle Width="150px" />
            </telerik:GridBoundColumn>
            
            <telerik:GridBoundColumn DataField="Registro" HeaderText="Registro" UniqueName="Registro">
                <HeaderStyle Width="150px" />
            </telerik:GridBoundColumn>
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
