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
                <textarea class="col-md-8" v-model="show.comment" placeholder="add your comment" required></textarea>
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
    //import the menu
    import MenuComponent from '../components/MenuComponent'
    const axios = require('axios');
    export default {
        name: "app",
        //show the menu
        components: {MenuComponent},
        computed: {
            //boolean hasComments - show the table if there comments for this show
            /**
             * @type {boolean}  boolean flag  - show the table if there comments for this show
             */
            hasComments() {
                return this.isLoading === false && this.comments.length > 0;
            },
            //boolean noComments - don't show the table, show the "No comments yet' message
            /**
             * @type {boolean}  boolean flag  - don't show the table, show the "No comments yet' message
             */
            noComments() {
                return this.isLoading === false && this.comments.length === 0;
            },
        },
        data() {
            return {
                /**
                 * @type {Object} comment object - the text of the comment, the user that left the comment and comment's id
                 */
                comment: {
                    comment: '',
                    username: '',
                    comment_id: ''
                },
                /**
                 * @type {[]} array for comments loaded from the database
                 */
                comments: [],
                /**
                 * @type {Object} show object - the text of the new comment and the name of the show
                 */
                show: {
                    name: '',
                    comment:''
                },
                /**
                 * @type {[]} array for shows loaded from the database with labels added
                 */
                options: [],
                /**
                 * @type {Object} option object - the name of the show and id in the list of options
                 */
                option: {
                    value: '',
                    label: ''
                },
                /**
                 * @type {[]} array for shows loaded from the database
                 */
                shows: [],
                //the selected show
                selected: null,
                isLoading: true,
                //the name of the user that is logged in
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
                        this.show.comment = "";
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
