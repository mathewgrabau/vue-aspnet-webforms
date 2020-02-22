<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RouterSample.aspx.cs" Inherits="VueWebForms.RouterSample" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Router Sample</h1>
    <p>This page demonstrates how to inject the Vue router as a single page.</p>
    <div class="container" id="app">
        <div class="row">First row goes here</div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" runat="server">
    <!-- Need the router scripts -->
    <%--<script type="text/javascript" src="Scripts/vue-router.common.js"></script>--%>
    <script type="text/javascript" src="Scripts/vue-router.js"></script>

    <script type="text/javascript">
        window.onload = function () {

            const RouteOneComponent = {
                template: `
                    <div>
                        <p>Welcome to the route 1 compoent.</p>
                        <router-link :to="{name: 'route2'}">Next</router-link>
                    </div>
                `
            };

            const RouteTwoComponent = {
                template: `
                    <div>
                        <p>Welcome to the second component.</p>
                        <router-link :to="{name: 'route1'}">Back</router-link>
                    </div>
                `
            };

            // Define your routes here.
            const routes = [
                {
                    path: '/',
                    name: 'route1',
                    component: RouteOneComponent
                },
                {
                    path: '/routes/2',
                    name: 'route2',
                    component: RouteTwoComponent
                }
            ]

            // Init the router.
            Vue.use(VueRouter);

            const router = new VueRouter({
                routes
            });

            // Initialize the different applications
            var app = {
                template: `
                    <router-view />
                `
            };

            new Vue({
                router,
                render: h => h(app)
            }).$mount('#app');
        };
    </script>
</asp:Content>
