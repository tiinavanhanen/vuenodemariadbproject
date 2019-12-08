<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
    <h1>Get recommendations</h1>
        <form @submit.prevent="handleSubmit">
            <v-select v-model="selected" :options="options" placeholder="Choose a genre">
                    {{option.label}}
            </v-select>
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
                ],
                option: {
                    value: '',
                    id: '',
                    label: ''
                }
            }
        },

        methods:{
            /**
             * Gets called when the genre is chosen and the "Display recommendatoins" button is pressed
             */
            handleSubmit() {
                const body = {
                    "genre": this.selected.id,
                };
                var uri = "http://localhost:3000/api/recommend/?username=" + localStorage.getItem('username') + "&genre=" + body.genre;
                axios
                    .get(uri)
                    .then( responce => {
                        /* eslint-disable no-console */
                        this.isLoading = false;
                        this.shows = responce.data;
                    });
            },
            /**
             * Loads all genres from the database
             * @return [] list of genre objects (genre_id and genre_name)
             */
            getGenres(){
                var uri="http://localhost:3000/api/genres";
                axios
                    .get(uri)
                    .then(responce =>{
                        this.genres=responce.data;
                        for(var i=0; i<this.genres.length; i++){
                            this.option.value = i;
                            this.option.label = this.genres[i].genre_name;
                            this.option.id = this.genres[i].genre_id;
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
            this.getGenres();
        }
    }
</script>

<style>

</style>
