<template>
    <div class="row justify-content-center">
        <menu-component></menu-component>
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
                    <td>{{ show.rating | numFormat('0.00') }} </td>
                </tr>
                </tbody>
            </table>
            <p v-if="noShows">No shows to recommend yet!</p>
        </div>
    </div>
</template>

<script>
    //import the menu
    import MenuComponent from '../components/MenuComponent'
    import 'vue-select/dist/vue-select.css';
    const axios = require('axios');
    export default {
        name: "app",
        //show the menu
        components: {MenuComponent},
        computed: {
            //boolean hasShows - show the table if there are shows to recommend
            /**
             * @type {boolean}  boolean flag  - show the table if there are shows to recommend
             */
            hasShows() {
                return this.isLoading === false && this.shows.length > 0;
            },
            //boolean noShows - don't show the table, show the "No shows to recommend yet' message
            /**
             * @type {boolean}  boolean flag  - don't show the table, show the "No shows  to recommend yet' message
             */
            noShows() {
                return this.isLoading === false && this.shows.length === 0;
            }
        },
        data() {
            return {
                show: {
                    genre: '',
                },
                /**
                 * @type {[]}  array for shows loaded from the database
                 */
                shows: [],
                isLoading: true,
                //the selected genre
                selected: null,
                /**
                 * @type {[]}  array containing genre options
                 */
                options: [],
                /**
                 * @type {Object} option object - the name(label)  and the id of the genre in the list of options
                 */
                option: {
                    value: '',
                    id: '',
                    label: ''
                }
            }
        },

        methods:{
            /**
             * Gets called when the genre is chosen and the "Display recommendations" button is pressed
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
