<%@ Page Title="" Language="C#" MasterPageFile="~/Shared/MasterPages/RLSiteMenu.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SPCi.Web.Applications.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <div>
  Página por defecto
 </div>

<telerik:RadAjaxPanel ID="RadAjaxPanel" runat="server" CssClass="grid_wrapper">
        <telerik:RadGrid ID="RadGrid2" runat="server" PageSize="10" PagerStyle-PageButtonCount="10"
            OnNeedDataSource="RadGrid1_NeedDataSource" AllowPaging="True" AllowSorting="true" ShowGroupPanel="True" RenderMode="Auto" Width="100%" Height="500px">
            <GroupingSettings ShowUnGroupButton="true" />
            <ExportSettings ExportOnlyData="true" IgnorePaging="true"></ExportSettings>
            <MasterTableView AutoGenerateColumns="False"
                AllowFilteringByColumn="True" TableLayout="Fixed"
                DataKeyNames="cch_id_camion" CommandItemDisplay="Top"
                InsertItemPageIndexAction="ShowItemOnFirstPage">
                <CommandItemSettings ShowExportToCsvButton="true" ShowExportToExcelButton="true" ShowExportToPdfButton="true" ShowExportToWordButton="true" RefreshText="Actualizar"/>
                <Columns>
        <telerik:GridBoundColumn DataField="cch_id_camion" HeaderText="Camion" SortExpression="cch_id_camion"
                        UniqueName="cch_id_camion">
                        <HeaderStyle Width="150px" />
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn DataField="cch_id_chofer" HeaderText="Chofer" SortExpression="cch_id_chofer"
                        UniqueName="cch_id_chofer">
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
<asp:Content ID="Content3" ContentPlaceHolderID="FooterContent" runat="server">
</asp:Content>
