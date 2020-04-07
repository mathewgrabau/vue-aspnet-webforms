<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RouterWithServerData.aspx.cs" Inherits="VueWebForms.RouterWithServerData" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Router with Parameters Sample</h1>
    <p>Sample demonstrating using more router features.</p>
    <div class="container" id="app">
        <div class="row"></div>
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" runat="server">
    <!-- Need the router scripts -->
    <%--<script type="text/javascript" src="Scripts/vue-router.common.js"></script>--%>
    <script type="text/javascript" src="Scripts/vue-router.js"></script>
    <script type="text/javascript" src="Scripts/axios.js"></script>

    <script type="text/javascript">
        window.onload = function () {

            // Add a response interceptor
            axios.interceptors.response.use(function (response) {
                // Any status code that lie within the range of 2xx cause this function to trigger
                // Do something with response data
                // Adjust the response here. ASP.NET seems to output this as the d of the response field.
                if (response.data && response.data["d"] !== undefined && response.data["d"] !== null) {
                    response.data = response.data["d"]; // Transform the object now.
                }
                return response;
            }, function (error) {
                // Any status codes that falls outside the range of 2xx cause this function to trigger
                // Do something with response error
                return Promise.reject(error);
            });

            const ListComponent = {
                data() {
                    return {
                        items: []
                    }
                },
                mounted() {
                    var url = '<%= ResolveUrl("~/RouterWithServerData.aspx/GetData") %>'
                    axios.post(url, {
                        headers: [
                            { 'Content-Type': "application/json; charset=utf-8"}
                        ]
                    }).then((response) => {
                        // Ensure there's something to actually assign here.
                        if (response.data) {
                            this.items = response.data;
                        }
                    });
                },
                template: `
                    <div>
                        <h2>Item List</h2>
                        
                        <router-link :to="{name: 'create'}" class="btn btn-link" role="button">Add New Record</router-link>

                        <table class="table">
                            <tr>
                                <th>Record ID</th>
                                <th>Title</th>
                                <th>Actions</th>
                            </tr>
                            <tr v-for="item in items">
                                <td>{{item.Id}}</td>
                                <td>{{item.Title}}</td>
                                <td><router-link :to="{name: 'edit', params: { id: item.Id }}" class="btn btn-link">Edit</router-link> <router-link :to="{name: 'delete', params: { id: item.Id }}" class="btn btn-link">Delete</router-link> </td>
                            </tr>
                        </table>
                        
                    </div>
                `
            };

            const EditComponent = {
                data() {
                    return {
                        record: {
                            Id: Number(this.$route.params.id),
                            Title: "",
                            Description: ""
                        }
                    }
                },
                mounted() {
                    var url = '<%= ResolveUrl("~/RouterWithServerData.aspx/GetData") %>'
                    axios.post(url, {
                        headers: [
                            { 'Content-Type': "application/json; charset=utf-8" }
                        ]
                    }).then((response) => {
                        // Check for the response data being present and extract the required components from there.
                        if (response.data) {
                            for (let index in response.data) {
                                if (response.data[index].Id === this.record.Id) {
                                    this.record.Title = response.data[index].Title;
                                    this.record.Description = response.data[index].Description;
                                }
                            }
                        }
                    });
                },
                methods: {
                    updateRecord() {
                        var url = '<%= ResolveUrl("~/RouterWithServerData.aspx/UpdateItem") %>'
                        axios.post(url, {
                            headers: [
                                { 'Content-Type': "application/json; charset=utf-8" }
                            ],
                            data: {
                                Id: this.record.Id,
                                Title: this.record.Title,
                                Description: this.record.Description
                            }
                        }).then((response) => {
                            // Check for the response data being present and extract the required components from there.
                            if (response.data) {
                                this.$router.go(-1);    // Assume that we have already updated things properly.
                            }
                        }).catch(() => {
                            alert("An error occurred during UpdateItem call or processing");
                        });
                    },
                    goBack() {
                        this.$router.go(-1);
                    }
                },
                template: `
                    <div>
                        <h2>Edit Item {{record.Id}}.</h2>
                        <form @submit.prevent="updateRecord">
                            <div class="form-group">
                                <label for="itemTitle">Item Title</label>
                                <input type="text" class="form-control" id="itemTitle" placeholder="Title" v-model="record.Title">
                            </div>
                            <div class="form-group">
                                <label for="itemDescription">Item Description</label>
                                <input type="text" class="form-control" id="itemDescription" placeholder="Description" v-model="record.Description">
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                            <button class="btn" @click="goBack" type="button">Back</button>
                        </form>
                       
                    </div>
                `
            };

            const CreateComponent = {
                data() {
                    return {
                        Id: 0,
                        Title: '',
                        Description: ''
                    }
                },
                methods: {
                    createRecord() {
                        //collectionData.push({ id: ++lastRecordId, title: this.title, description: this.description });
                        var url = '<%= ResolveUrl("~/RouterWithServerData.aspx/CreateItem") %>'
                        axios.post(url, {
                            headers: [
                                { 'Content-Type': "application/json; charset=utf-8" }
                            ],
                            data: {
                                Id: 0,
                                Title: this.Title,
                                Description: this.Description
                            }
                        }).then((response) => {
                            // Check for the response data being present and extract the required components from there.
                            if (response.data) {
                                this.$router.replace({ name: 'list' });   // Go back to the exisitng location.
                            }
                        }).catch(() => {
                            alert("Failed during processing/call to CreateItem");
                        });
                    },
                    goBack() {
                        // Just abort, could show the usual sort of "you've edited data" if desired.
                        this.$router.replace({ name: 'list' });
                    }
                },
                template: `
                    <div> 
                        <h2>Create New Record</h2>
                        <form @submit.prevent="createRecord">
                            <div class="form-group">
                                <label for="itemTitle">Item Title</label>
                                <input type="text" class="form-control" id="itemTitle" placeholder="Title" v-model="Title">
                            </div>
                            <div class="form-group">
                                <label for="itemDescription">Item Description</label>
                                <input type="text" class="form-control" id="itemDescription" placeholder="Description" v-model="Description">
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                            <button type="button" class="btn btn-default" @click="goBack">Cancel</button>
                        </form>
                    </div>
                `
            };

            const DeleteComponent = {
                data() {
                    return {
                        recordId: Number(this.$route.params.id)
                    }
                },

                methods: {
                    deleteRecord() {
                        var url = '<%= ResolveUrl("~/RouterWithServerData.aspx/DeleteItem") %>'
                        axios.post(url, {
                            headers: [
                                { 'Content-Type': "application/json; charset=utf-8" }
                            ],
                            data: {
                                Id: this.recordId
                            }
                        }).then((response) => {
                            // Check for the response data being present and extract the required components from there.
                            if (response.data) {
                                // TODO could use a nice notification here or something to let us know that things have been deleted properly.
                            }

                            router.replace({ name: 'list' });   // Go back to the exisitng location.
                        });

                        // Ensure the development is now updated.
                    },
                    cancelDelete() {
                        // TODO this probably needs a better check on whether we should go back ther.e
                        this.$router.go(-1);
                    }
                },
                
                template: `
                    <div>
                        <form @submit.prevent="deleteRecord">
                            <p>Delete record {{recordId}}?</p>
                            <button class="btn btn-danger" type="submit">Confirm</button> <button class="btn btn-default" type="button" @click="cancelDelete">Cancel</button>
                        </form>
                    </div>
                `
            }


            // Define your routes here.
            const routes = [
                {
                    path: '/',
                    name: 'list',
                    component: ListComponent
                },
                {
                    path: '/create',
                    name: 'create',
                    component: CreateComponent
                },
                {
                    path: '/edit/:id',
                    name: 'edit',
                    component: EditComponent
                },
                {
                    path: '/delete/:id',
                    name: 'delete',
                    component: DeleteComponent
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
