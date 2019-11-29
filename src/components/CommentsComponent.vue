<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Comments</h1>
            <form @submit.prevent="handleSubmit">
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
                    <tr v-for="comment in comments" :key="comment.id" >
                        <td>{{ comment.comment }} </td>
                        <td>{{ comment.username }} </td>
                    </tr>
                </tbody>
            </table>
            <p v-if="noComments">No comments yet!</p>
        </div>
    </div>

</template>

<script>
    const axios = require('axios');
    export default {
        name: "app",
        computed: {
            hasComments() {
                return this.isLoading === false && this.comments.length > 0;
            },
            noComments() {
                return this.isLoading === false && this.comments.length === 0;
            }
        },
        data() {
            return {
                comment: {
                    comment: '',
                    username: '',
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
            }
        },
        methods:{
            handleSubmit() {
                /* eslint-disable no-console */
                console.log( this.show.name);
                this.loadComments(this.selected.label);
                document.getElementById("addComment").style="display: initial"
            },

            handleCommentSubmit(){
                const body = {
                    "showname": this.selected.label,
                    "comment": this.show.comment
                };
                var uri = "http://localhost:3000/api/addcomment/?showname=" + body.showname + "&comment=" + body.comment;
                axios
                    .get(uri)
                    .then( responce => {
                        console.log( "got a comment result");
                        console.log(responce);
                        this.loadComments();
                    });
            },
            loadComments() {
                const body = {
                    "showname": this.selected.label
                };
                var uri = "http://localhost:3000/api/comments/?showname=" +body.showname;
                axios
                    .get(uri)
                    .then( responce => {
                        this.isLoading = false;
                        console.log( "got a result");
                        console.log(responce);
                        this.comments = responce.data;
                        console.log(JSON.stringify(this.comments));
                    } )
                    .catch( err => {
                        console.log( err );
                    } );
            },
            getShowNames(){
                var uri="http://localhost:3000/api/all_shows";
                axios
                    .get(uri)
                    .then(responce =>{
                        this.shows=responce.data;
                        console.log( this.shows );
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
            }
        },
        mounted() {
            this.getShowNames();
        }
    }
</script>