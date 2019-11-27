<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
    <h1>Get recommendations</h1>

        <form @submit.prevent="handleSubmit">
    <v-select v-model="selected" :options="options" placeholder="Choose a genre">
        <template slot="option" slot-scope="option">{{option.label}}
        </template></v-select>
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
                    <td><router-link :to="{name: 'show', params: {series_name: show.series_name}}">{{ show.series_name }}</router-link> </td>
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
    import 'vue-select/dist/vue-select.css';
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
                selected: null,
                options: [
                    {value: null, label: ''},
                    {value: 16, label: 'animation'},
                    {value: 18, label: 'drama'},
                    {value: 35, label: 'comedy'},
                    {value: 37, label: 'western'},
                    {value: 80, label: 'crime'},
                    {value: 99, label: 'documentary'},
                    {value: 9648, label: 'mystery'},
                    {value: 10751, label: 'family'},
                    {value: 10759, label: 'action & adventure'},
                    {value: 10762, label: 'kids'},
                    {value: 10763, label: 'news'},
                    {value: 10764, label: 'reality'},
                    {value: 10765, label: 'sci-fi & fantasy'},
                    {value: 10766, label: 'soap'},
                    {value: 10767, label: 'talk'},
                    {value: 10768, label: 'war & politics'}
                ],

            }
        },

        methods:{

            handleSubmit() {
                const body = {
                    "genre": this.selected.value,
                };

                var uri = "http://localhost:3000/api/recommend/?username=" + "testuser" + "&genre=" + body.genre;
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

<style>

</style>