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
                    ❗An error has occurred
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
                </tr>
                </thead>
                <tbody>
                <tr :key="series.id" v-for="series in shows">
                    <td>{{series.series_name}}</td>
                    <td v-if="editing === series.id">
                        <input type="number" v-model="series.season">
                    </td>
                    <td v-else>{{series.season}}</td>
                    <td v-if="editing === series.id">
                        <input type="number" v-model="series.episode">
                    </td>
                    <td v-else>{{series.episode}}</td>
                    <td v-if="editing === series.id">
                        <button @click="editSeries(series)">Save</button>
                        <button class="muted-button" @click="cancelEdit(series)">Cancel</button>
                    </td>
                    <td v-else>
                        <button @click="editMode(series)">Edit</button>
                        <button @click="deleteSeries">Delete</button>
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
                    season: '',
                    episode: '',
                },
                shows: [],
                isLoading: true,
                editing: null,
                submitting: false,
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
                        } else {
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
                        // eslint-disable-next-line no-console
                        console.log(JSON.stringify(this.shows));
                    });
            },
            editSeries() {
                // eslint-disable-next-line no-console
                console.log("editing series");
                const body = {
                    "showname": this.series.series_name,
                    "season": this.series.season,
                    "episode": this.series.episode,
                };
                axios
                    .get("http://localhost:3000/api/editseries/?username=" + "testuser" + "&showname=" + body.showname + "&season=" + body.season
                    + "&episode" + body.episode)
                    .then( response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.editing = null;
                        this.loadShows();
                    });
            },
            deleteSeries() {
                const body = {
                    "showname": this.series.series_name,
                };

                axios
                    .get("http://localhost:3000/api/deleteseries/?username=" + "testuser" + "&showname=" + body.showname)
                    .then( response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.loadShows();
                    });
            },
            editMode(series) {
                this.cachedSeries = Object.assign({}, series);
                this.editing = series.id;
                // eslint-disable-next-line no-console
                console.log("cached series: " + series);
            },
            cancelEdit(series) {
                Object.assign(series, this.cachedSeries);
                this.editing = null;
                // eslint-disable-next-line no-console
                console.log("retrieved from cache series: " + series);
            },
            edit(series) {
                if (series.series_name === '' || series.season === '' || series.episode === '') return;
                this.editSeries();
                this.editing = null;
            }
        },
        computed: {
            invalidName() {
                return this.series.series_name === ''
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