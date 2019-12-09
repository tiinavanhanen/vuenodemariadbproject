<template>
    <div class="row justify-content-center">
        <menu-component></menu-component>
        <div class="col-md-8">
            <h1>Comments</h1>
            <form @submit.prevent="loadComments">
                <v-select v-model="selected" :options="options" placeholder="Choose a show">
                    <template slot="option" slot-scope="option">{{option.label}}
                    </template></v-select>
                <button>Display comments</button>
            </form>
            <form @submit.prevent="handleCommentSubmit" id="addComment" style="display: none">
                <label>Add comment</label>
                <br>
                <textarea class="col-md-8" v-model="show.comment" placeholder="add your comment"></textarea>
                <br>
                <button>Add</button>
            </form>
            <table class="table table-striped" v-if="hasComments">
                <thead>
                    <tr>
                        <th>Comment</th>
                        <th>User</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="comment in comments" :key="comment.comment_id" >
                        <td>{{ comment.comment }} </td>
                        <td>{{ comment.username }} </td>
                        <td>
                            <template v-if="comment.username === loggedUser">
                            <button @click="deleteComment(comment)">Delete</button>
                            </template>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p v-if="noComments">No comments yet!</p>
        </div>
    </div>

</template>

<script>
    import MenuComponent from '../components/MenuComponent'
    const axios = require('axios');
    export default {
        name: "app",
        components: {MenuComponent},
        computed: {
            hasComments() {
                return this.isLoading === false && this.comments.length > 0;
            },
            noComments() {
                return this.isLoading === false && this.comments.length === 0;
            },
        },
        data() {
            return {
                comment: {
                    comment: '',
                    username: '',
                    comment_id: ''
                },
                comments: [],
                show: {
                    name: '',
                    comment:''
                },
                options: [],
                option: {
                    value: '', label: ''
                },
                shows: [],
                selected: null,
                isLoading: true,
                loggedUser: localStorage.getItem('username')
            }
        },
        methods:{
            /**
             * Gets called when the "Add" button is pressed in order to add a comment
             */
            handleCommentSubmit(){
                const body = {
                    "showname": this.selected.label,
                    "comment": this.show.comment
                };
                var loggeduser = localStorage.getItem('username');
                var uri = "http://localhost:3000/api/addcomment/?showname=" + body.showname + "&username=" + loggeduser + "&comment=" + body.comment;
                axios
                    .get(uri)
                    .then( responce => {
                        /* eslint-disable no-console */
                        console.log(responce);
                        this.loadComments();
                    });
            },
            /**
             * Gets called when the name of the show is chosen and the button "Display comments" is pressed or when a new comment has been added
             */
            loadComments() {
                document.getElementById("addComment").style="display: initial";
                const body = {
                    "showname": this.selected.label
                };
                var uri = "http://localhost:3000/api/comments/?showname=" +body.showname;
                axios
                    .get(uri)
                    .then( responce => {
                        this.isLoading = false;
                        this.comments = responce.data;
                    } )
                    .catch( err => {
                        console.log( err );
                    } );
            },
            /**
             * Gets called automatically when the page is opened in order to get the options for the dropdown list with the shows' names
             */
            getShowNames(){
                var uri="http://localhost:3000/api/all_shows";
                axios
                    .get(uri)
                    .then(responce =>{
                        this.shows=responce.data;
                        for(var i=0; i<this.shows.length; i++){
                            this.option.value = i;
                            this.option.label = this.shows[i].series_name;
                            this.options.push(this.option);
                            this.option = {value: '', label: ''}
                        }

                    })
                    .catch(err => {
                        console.log( err );
                    })
            },
            /**
             * Gets called when user presses "Delete" button in order to delete one of the comments
             * @param comment The comment object that will be deleted
             */
            deleteComment(comment) {
                var uri = "http://localhost:3000/api/deletecomment/?commentid=" + comment.comment_id;
                axios
                    .get(uri)
                    .then(responce =>{
                        console.log(responce);
                        this.loadComments();
                    })
                    .catch(err => {
                        console.log(err)
                    })
            }
        },
        mounted() {
            this.getShowNames();
        }
    }
</script>
