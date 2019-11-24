<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Comments</h1>

            <form @submit.prevent="handleSubmit">
                <label>Show's name</label>
                <input
                        type="text"
                        v-model="show.name"
                />
                <button>Display comments</button>
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
                  name: ''
                },
                isLoading: true,
            }
        },


        methods:{

            handleSubmit() {

                /* eslint-disable no-console */
                console.log( this.show.name);
                /* eslint-enable no-console */
                this.loadShows(this.show.name)
            },

            loadShows() {
                const body = {
                    "showname": this.show.name
                };
                var uri = "http://localhost:3000/api/comments/?showname=" +body.showname;
                axios
                    .get(uri)
                    .then( responce => {
                        this.isLoading = false;
                        /* eslint-disable no-console */
                        console.log( "got a result");
                        console.log(responce);
                        this.comments = responce.data;
                        console.log(JSON.stringify(this.comments));
                    } )
                    .catch( err => {
                        //this.msg = err.message;
                        /* eslint-disable no-console */
                        console.log( err );
                        /* eslint-enable no-console */
                    } );
            }
        },
    }
</script>