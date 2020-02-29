<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RouterWithParameters.aspx.cs" Inherits="RouterWithServerData" %>
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

    <script type="text/javascript">
        window.onload = function () {

            // Create a simulated collection of items.
            const collectionData = [
                {
                    id: 1,
                    title: 'Item 1',
                    description: 'First item in the collection'
                },
                {
                    id: 2,
                    title: 'Item 2',
                    description: 'Second item in the collection'
                },
                {
                    id: 3,
                    title: 'Item 3',
                    description: 'Third item in the collection'
                }
            ];

            let lastRecordId = collectionData.length;   // NOTE: This is just for demonstration.

            const ListComponent = {
                data() {
                    return {
                        items: collectionData
                    }
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
                                <td>{{item.id}}</td>
                                <td>{{item.title}}</td>
                                <td><router-link :to="{name: 'edit', params: { id: item.id }}" class="btn btn-link">Edit</router-link> <router-link :to="{name: 'delete', params: { id: item.id }}" class="btn btn-link">Delete</router-link> </td>
                            </tr>
                        </table>
                        
                    </div>
                `
            };

            const EditComponent = {
                data() {
                    return {
                        record: {
                            id: Number(this.$route.params.id),
                            title: "",
                            description: ""
                        }
                    }
                },
                mounted() {
                    // Populate the collection here
                    for (let r in collectionData) {
                        if (this.record.id === collectionData[r].id) {
                            this.record.title = collectionData[r].title;
                            this.record.description = collectionData[r].description;
                        }
                    }
                },
                methods: {
                    updateRecord() {
                        for (let r in collectionData) {
                            if (this.record.id === collectionData[r].id) {
                                collectionData[r].title = this.record.title;
                                collectionData[r].description = this.record.description;
                                this.$router.go(-1);
                            }
                        }
                    },
                    goBack() {
                        this.$router.go(-1);
                    }
                },
                template: `
                    <div>
                        <h2>Edit Item {{record.id}}.</h2>
                        <form @submit.prevent="updateRecord">
                            <div class="form-group">
                                <label for="itemTitle">Item Title</label>
                                <input type="text" class="form-control" id="itemTitle" placeholder="Title" v-model="record.title">
                            </div>
                            <div class="form-group">
                                <label for="itemDescription">Item Description</label>
                                <input type="text" class="form-control" id="itemDescription" placeholder="Description" v-model="record.description">
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
                        id: 0,
                        title: '',
                        description: ''
                    }
                },
                methods: {
                    createRecord() {
                        collectionData.push({ id: ++lastRecordId, title: this.title, description: this.description });
                        router.replace({ name: 'list' });   // Go back to the exisitng location.
                    }
                },
                template: `
                    <div> 
                        <h2>Create New Record</h2>
                        <form @submit.prevent="createRecord">
                            <div class="form-group">
                                <label for="itemTitle">Item Title</label>
                                <input type="text" class="form-control" id="itemTitle" placeholder="Title" v-model="title">
                            </div>
                            <div class="form-group">
                                <label for="itemDescription">Item Description</label>
                                <input type="text" class="form-control" id="itemDescription" placeholder="Description" v-model="description">
                            </div>
                            <button type="submit" class="btn btn-default">Submit</button>
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
                        let removeIndex = -1;
                        for (let recordIndex in collectionData) {
                            if (collectionData[recordIndex].id === this.recordId) {
                                removeIndex = recordIndex;
                                break;
                            }
                        }

                        // Execute the remove operation here.
                        if (removeIndex >= 0) {
                            collectionData.splice(removeIndex, 1);
                            this.$router.go(-1);
                        } else {
                            // TODO need an error somehow.
                        }
                    },
                    cancelDelete() {
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
