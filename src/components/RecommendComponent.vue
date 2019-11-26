<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
    <h1>Get recommendations</h1>

    <form @submit.prevent="handleSubmit">
        <label>Show's genre</label>
        <input
                type="text"
                v-model="show.genre"
        />
        <button>Display recommendations</button>
    </form>

            <table class="table table-striped" v-if="hasShows">

                <thead>
                <tr>
                    <th>Name</th>
                    <th>Votes</th>
                    <th>Rating</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="show in shows" :key="show.id" >
                    <td>{{ show.series_name }} </td>
                    <td>{{ show.votes }} </td>
                    <td>{{ show.rating }}</td>
                </tr>
                </tbody>
            </table>
            <p v-if="noShows">No shows to recommend yet!</p>
        </div>
    </div>
</template>

<script>
    const axios = require('axios');
    export default {

        name: "app",
        computed: {
            hasShows() {
                return this.isLoading === false && this.shows.length > 0;
            },
            noShows() {
                return this.isLoading === false && this.shows.length === 0;
            }
        },
        data() {
            return {
                show: {
                    genre: '',

                },
                shows: [],
                isLoading: true,
            }
        },

        methods:{

            handleSubmit() {
                const body = {
                    "genre": this.show.genre,
                };
                var uri = "http://localhost:8080/api/recommend/?username=" + "testuser" + "&genre=" + body.genre;
                axios
                    .get(uri)
                    .then( responce => {
                        /* eslint-disable no-console */
                        console.log( "got a recommend result");
                        this.isLoading = false;
                        console.log(responce);
                        this.shows = responce.data;

                    });
            }
        }
    }
</script>

<style scoped>

</style>