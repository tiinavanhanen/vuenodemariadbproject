<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Add a show</h1>
            <form @submit.prevent="addSeries">
                <label>Series name</label>
                <input type="text" v-model="series.series_name"/>
                <button>Add series</button>
                <p v-if="success" class="success-message">
                    ✅ Series successfully added
                </p>
                <p v-if="check" class="error-message">
                    ❗Series is already on your list
                </p>
                <p v-if="error" class="error-message">
                    ❗We could not find a series by this name
                </p>
                <p v-if="isNegative" class="error-message">
                    ❗Both season and episode must be positive numbers
                </p>
            </form>
        </div>
        <div class="col-md-8" id="ownseries">
            <p v-if="shows.length < 1" class="empty-table">
                No series yet
            </p>
            <table class="table table-striped" v-else>
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Season</th>
                    <th>Episode</th>
                    <th v-if="editing !== null">Rating</th>
                </tr>
                </thead>
                <tbody>
                <tr :key="show.series_name" v-for="show in shows">
                    <td>{{show.series_name}}</td>
                    <td v-if="editing === show.series_name">
                        <input type="number" min="1" v-model="show.season">
                    </td>
                    <td v-else>{{show.season}}</td>
                    <td v-if="editing === show.series_name">
                        <input type="number" min="1" v-model="show.episode">
                    </td>
                    <td v-else>{{show.episode}}</td>
                    <td v-if="editing === show.series_name">
                        <v-select v-model="show.score" :options="options" placeholder="">
                        </v-select>
                    </td>
                    <td v-if="editing === show.series_name">
                        <button @click="editSeries(show)">Save</button>
                        <button class="muted-button" @click="cancelEdit(show)">Cancel</button>
                    </td>
                    <td v-else>
                        <button @click="editMode(show)">Edit</button>
                        <button @click="deleteSeries(show)">Delete</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script>
    const axios = require('axios');
    export default {
        name: "app",
        data() {
            return {
                success: false,
                error: false,
                check: false,
                series: {
                    series_name: '',
                },
                show: {
                    series_name: '',
                    season: '',
                    episode: '',
                    score: '',
                },
                shows: [],
                options: [1,2,3,4,5],
                isLoading: true,
                editing: null,
                submitting: false,
                isNegative: false,
            }
        },
        methods: {
            addSeries() {
                // eslint-disable-next-line no-console
                console.log("lisätään sarjaa");
                this.submitting = true;
                const body = {
                    "showname": this.series.series_name
                };
                var uri = "http://localhost:3000/api/addseries/?showname=" + body.showname + "&username=" + "testuser";
                axios
                    .get(uri)
                    .then(response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        if (response.data === "on jo") {
                            this.check = true;
                            this.success = false;
                            this.error = false;
                        } else if (response.data === "sarja lisätty") {
                            this.success = true;
                            this.check = false;
                            this.error = false;
                            this.series.series_name = '';
                            this.loadShows();
                        } else if (response.data === "sarjaa ei löytynyt") {
                            this.error = true;
                            this.check = false;
                            this.success = false;
                        }
                        this.submitting = false;
                    });
            },
            loadShows() {
                axios
                    .get("http://localhost:3000/api/ownseries/?username=" + "testuser")
                    .then( response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.shows = response.data;
                        // eslint-disable-next-line no-console
                        console.log(this.shows);
                    });
            },
            editSeries(show) {
                if (show.series_name === '' || show.season === '' || show.episode === '') return;
                if (show.season < 1 || show.episode < 1) {
                    this.isNegative = true;
                } else {
                    this.isNegative = false;
                    // eslint-disable-next-line no-console
                    console.log("editing series: " + JSON.stringify(show));
                    // eslint-disable-next-line no-console
                    console.log("komponentissa name, score " + show.series_name + show.score);
                    axios
                        .get("http://localhost:3000/api/editseries/?username=" + "testuser" + "&showname=" + show.series_name +
                            "&season=" + show.season + "&episode=" + show.episode + "&score=" + show.score)
                        .then( response => {
                            // eslint-disable-next-line no-console
                            console.log(response);
                            this.editing = null;
                            this.loadShows();
                        });
                }
            },
            deleteSeries(show) {
                // eslint-disable-next-line no-console
                console.log("deleting series: " + JSON.stringify(show));
                // eslint-disable-next-line no-console
                //console.log("komponentissa nimi " + show.series_name);
                axios
                    .get("http://localhost:3000/api/deleteseries/?username=" + "testuser" + "&showname=" + show.series_name)
                    .then( response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.loadShows();
                    });
            },
            editMode(series) {
                this.cachedSeries = Object.assign({}, series);
                this.editing = series.series_name;
                // eslint-disable-next-line no-console
                console.log("cached series: " + JSON.stringify(series));
            },
            cancelEdit(series) {
                Object.assign(series, this.cachedSeries);
                this.editing = null;
                // eslint-disable-next-line no-console
                console.log("retrieved from cache series: " + JSON.stringify(series));
            },
        },
        mounted() {
            return this.loadShows();
        }

    }
</script>

<style scoped>
    .success-message {
        color: #32a95d;
    }
    .error-message {
        color: #d33c40;
    }
</style>
