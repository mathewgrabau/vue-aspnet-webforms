<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EventHandlerPage.aspx.cs" Inherits="VueWebForms.EventHandlerPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Event Handler Test</h1>

    <div class="row" id="app">
        <div class="col-md-4">
            The last time of the click was: {{ lastClickTime }}
        </div>
        <div class="col-md-4">
            <button class="btn btn-primary" type="button" @click.prevent="clickHandler">Update Date</button>
        </div>
    </div>

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