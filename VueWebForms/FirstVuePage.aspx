<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FirstVuePage.aspx.cs" Inherits="VueWebForms.FirstVuePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>First Vue Page</h1>

    <div id="app">
        {{ message }}
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            // Initialize the different applications
            var app = new Vue({
                el: '#app',
                data: {
                    message: 'Hello from Vue!'
                }
            });
        };
    </script>
</asp:Content>