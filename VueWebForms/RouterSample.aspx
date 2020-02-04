<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RouterSample.aspx.cs" Inherits="VueWebForms.RouterSample" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            // Initialize the different applications
            var app = new Vue({
                el: '#app',
                data: {
                    lastClickTime: null
                },
                methods: {
                    clickHandler() {
                        this.lastClickTime = new Date();
                    }
                }
            });
        };
    </script>
</asp:Content>
