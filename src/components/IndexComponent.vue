<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>All shows</h1>
            <table class="table table-striped" v-if="hasShows">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Votes</th>
                    <th>Rating</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="show in shows" :key="show.series_name" >
                    <td><router-link :to="{name: 'show', params: {series_name: show.series_name}}">{{ show.series_name }}</router-link> </td>
                    <td>{{ show.votes }} </td>
                    <td>{{ show.rating }}</td>
                </tr>
                </tbody>
            </table>
            <p v-if="noShows">No shows yet!</p>
        </div>
    </div>
</template>

<script>
    const axios = require('axios');
    export default {
        name: "app",
        props:['key'],
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
                    series_name: '',
                    votes: '',
                    rating: '',
                },
                shows: [],
                isLoading: true,
            }
        },

        methods:{
            loadShows() {
                axios
                    .get( "http://localhost:3000/api/all_shows")
                    .then( responce => {
                        this.isLoading = false;
                        /* eslint-disable no-console */
                        console.log( "got a result");
                        this.shows = responce.data;
                        console.log(JSON.stringify(this.shows));
                    } )
                    .catch( err => {
                        console.log( err );
                    } );
            }
        },
        mounted() {
            return this.loadShows();
        }
    }
</script>